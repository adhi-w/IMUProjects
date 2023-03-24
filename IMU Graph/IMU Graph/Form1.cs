using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Diagnostics;
using System.IO;
using System.IO.Ports;

using OpenTK;
using OpenTK.Graphics;
using OpenTK.Graphics.OpenGL;


namespace IMU_Graph
{
    public partial class Form1 : Form
    {
        bool loaded = false;
        
        int x = 0;
        float rotation = 0;

        double accumulator = 0;
        int idleCounter = 0;

        Matrix4 matModelview, matPerspective;
        Matrix4 matMVP = Matrix4.Identity;
        Matrix4 matrix;

        private string sData;

        int[] ypr1 = new int[3];
        int[] ypr2 = new int[3];
        int ID1, ID2;

        String dat1, dat2;
        StreamWriter file1 = new StreamWriter("data1.txt");
        StreamWriter file2 = new StreamWriter("data2.txt");
       

        class Bone
        {
            public string Name;
            public Vector3 LocalPosition;
            public Vector3 Position;
            public float Angle;
            public float Length;
            public Bone Parent;

        }
        public Form1()
        {   
            InitializeComponent();
            GetAvailablePort();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            comPort1.Text = "COM22";
            Baudrate1.Text = "38400";

            comPort2.Text = "COM17";
            Baudrate2.Text = "38400";

            if (serialPort1.IsOpen)
            {
                sData = "";
                m_sData1.Text = "";
            }

            if (serialPort2.IsOpen)
            {                
                m_sData2.Text = "";
            }

            serialPort1.DataReceived += new SerialDataReceivedEventHandler(serialPort1_DataReceived);
            
        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (serialPort1.IsOpen && serialPort2.IsOpen) { serialPort1.Close(); serialPort2.Close(); }
        }

        Stopwatch sw = new Stopwatch(); // available to all event handlers

        void GetAvailablePort()
        {
            String[] ports = SerialPort.GetPortNames();
            comPort1.Items.AddRange(ports);
            comPort2.Items.AddRange(ports);
        }
        void Application_Idle(object sender, EventArgs e)
        {
            double milliseconds = ComputeTimeSlice();
            Accumulate(milliseconds);
            Animate(milliseconds);
        }
        

        private void Animate(double milliseconds)
        {
            float deltaRotation = (float)milliseconds / 20.0f;
            rotation += deltaRotation;
            glControl1.Invalidate();
        }

        private void Accumulate(double milliseconds)
        {
            idleCounter++;
            accumulator += milliseconds;
            if (accumulator > 1000)
            {
                //label1.Text = idleCounter.ToString();
                accumulator -= 1000;
                idleCounter = 0; // don't forget to reset the counter!
            }
        }

        private double ComputeTimeSlice()
        {
            sw.Stop();
            double timeslice = sw.Elapsed.TotalMilliseconds;
            sw.Reset();
            sw.Start();
            return timeslice;
        }

        
        double Deg2Rad(double d)
        { return d * 3.14 / 180; }
        
        float l1 = 5, l2 = 2;
        double xt1 = 0f, yt1 = 0f, zt1=0f;
        double xt2 = 0f, yt2 = 0f;
        void ForwardKinematic(int[] theta1, int[] theta2)
        {
            zt1 = l1 * Math.Cos(Deg2Rad(theta1[1]));

            xt1 = l1 * Math.Cos(Deg2Rad(theta1[0]));
            yt1 = l1 * Math.Sin(Deg2Rad(theta1[0]));

            xt2 = l1 * Math.Cos(Deg2Rad(theta1[0])) + l2 * Math.Cos(Deg2Rad(theta2[0]));
            yt2 = l1 * Math.Sin(Deg2Rad(theta1[0])) + l2 * Math.Sin(Deg2Rad(theta2[0]));
        }



        private void SetupViewport()
        {
            int w = glControl1.Width;
            int h = glControl1.Height;

            //matModelview = Matrix4.LookAt(new Vector3(0, 0, 40), new Vector3(0, 1, 0), Vector3.UnitY);
            //matPerspective = Matrix4.CreatePerspectiveFieldOfView((float)Math.PI / 4, (float)w / h, 0.1f, 100f);

            matPerspective = Matrix4.CreatePerspectiveFieldOfView((float)0.14, (float)4 / 3, 1f, 10000f);
            matModelview = Matrix4.LookAt(50, 50, 20, 0, 0, 0, 0, 0, 1); //Setup camera
            matMVP = matModelview * matPerspective;

            GL.MatrixMode(MatrixMode.Projection);
            GL.LoadIdentity();
            GL.LoadMatrix(ref matMVP);

            //GL.Ortho(0, w, 0, h, -1, 100);    // Bottom-left corner pixel has coordinate (0,0)
            GL.Viewport(0, 0, w, h); // Use all of the glControl painting area
            GL.Enable(EnableCap.DepthTest);  //Enable correct Z Drawings
            GL.DepthFunc(DepthFunction.Less); //Enable correct Z Drawings
        }
        private void glControl1_Load(object sender, EventArgs e)
        {
            loaded = true;
            GL.ClearColor(Color.SteelBlue);

            SetupViewport();
            Application.Idle += Application_Idle;

            sw.Start(); // start at application boot
        }
        private void glControl1_Paint(object sender, PaintEventArgs e)
        {
            if (!loaded)
                return;           
           
            ForwardKinematic(ypr1, ypr2);

            // Create bones in local space
            Bone root, body, head;
            root = new Bone { Name = "root", LocalPosition = new Vector3(0, 0, 0) };
            body = new Bone { Name = "body", LocalPosition = new Vector3(0, 5, 0) }; 
            head = new Bone { Name = "head", LocalPosition = new Vector3(0, 2, 0) };
            // Set hierarchy of bones
            body.Parent = root;
            head.Parent = body;

            GL.Clear(ClearBufferMask.ColorBufferBit | ClearBufferMask.DepthBufferBit);

            GL.MatrixMode(MatrixMode.Modelview);
            GL.LoadIdentity();

            //GL.Translate(x, 0, 0); // position triangle according to our x variable

            body.Angle = (float)ypr1[0] * (float)(3.14 / 180); // rotation;   // rad
            head.Angle = ((float)ypr2[0] - (float)ypr1[0]) * (float)(3.14 / 180);// rotation;

            float pitchAngle = (float)ypr1[2] * (float)(3.14 / 180);
            

            // Do transformations
            matrix = Matrix4.CreateTranslation(root.LocalPosition);

            // Remove these two lines below if you do not want to move the skeleton
            //matrix *= Matrix4.CreateTranslation(Vector3.UnitY);
            //matrix *= Matrix4.CreateRotationZ(body.Angle);
            
            // Remove these two lines above if you do not want to move the skeleton

            //root.Position += matrix.Row3.Xyz;

            matrix =
                   Matrix4.CreateTranslation(body.LocalPosition) *
                   Matrix4.CreateRotationZ(body.Angle) *
                   //Matrix4.CreateRotationY(pitchAngle) *
                   Matrix4.CreateTranslation(body.Parent.Position);
            body.Position = matrix.Row3.Xyz;

            matrix =
                Matrix4.CreateTranslation(head.LocalPosition) *
                Matrix4.CreateRotationZ(head.Angle + head.Parent.Angle) *
                Matrix4.CreateTranslation(head.Parent.Position);
            head.Position = matrix.Row3.Xyz;

            /////////////-----------------Forward Kinematics Animation--------------//////////////////
           
            // Draw Bones
            //GL.Begin(PrimitiveType.Lines);            
            //GL.Color3(Color.Purple);            
            //GL.Vertex3(0, 0, 0);
            //GL.Vertex3(xt1, yt1, zt1);
            //GL.Vertex3(xt1, yt1, zt1);
            //GL.Vertex3(xt2, yt2, 0);
            //GL.End();
            
            //// Draw joints
            //GL.Color3(1f, 0f, 0f);
            //GL.PointSize(8f);
            //GL.Begin(PrimitiveType.Points);
            //GL.Vertex3(0, 0, 0);
            //GL.Vertex3(xt1, yt1, zt1);
            //GL.Vertex3(xt2, yt2, 0);
            //GL.End();        

            GL.Begin(PrimitiveType.Lines);
            GL.Color3(Color.Red);
            GL.Vertex3(0, 0, 0);
            GL.Vertex3(5, 0, 0);

            GL.Color3(Color.Blue);
            GL.Vertex3(0, 0, 0);
            GL.Vertex3(0,5, 0);

            GL.Color3(Color.Green);
            GL.Vertex3(0, 0, 0);
            GL.Vertex3(0, 0, 5);

            GL.End();

            //label3.Text = String.Format("{0:N}  {1:N}       {2:N}  {3:N}", xt1, yt1, xt2, yt2);
            label3.Text = "Violet Lines are based on forward Kinematics && White lines are based on openTK lib Matrix movement";
            ////////////////////////////////////////////
                        
            //GL.Color3(Color.White);
            //// Draw bones
            //GL.Begin(PrimitiveType.Lines);
            //GL.Vertex3(body.Parent.Position);
            //GL.Vertex3(body.Position);
            //GL.Vertex3(head.Parent.Position);
            //GL.Vertex3(head.Position);
            //GL.End();

            //// Draw joints
            //GL.Color3(1f, 0f, 0f);
            //GL.PointSize(10f);
            //GL.Begin(PrimitiveType.Points);
            //GL.Vertex3(root.Position);
            //GL.Vertex3(body.Position);
            //GL.Vertex3(head.Position);
            //GL.End();

            RectJoint_1();  //xt1, yt1, zt1);
           // RectJoint_2(); 

            //////////////////////////////////////////////
            /*
            GL.Begin(BeginMode.Triangles);

            //Face 1
            GL.Color3(Color.Red);
            GL.Vertex3(5, 0, 0);
            GL.Color3(Color.White);
            GL.Vertex3(0, 2.5, 0);
            GL.Color3(Color.Blue);
            GL.Vertex3(0, 0, 5);
            //Face 2
            GL.Color3(Color.Green);
            GL.Vertex3(-5, 0, 0);
            GL.Color3(Color.White);
            GL.Vertex3(0, 2.5, 0);
            GL.Color3(Color.Blue);
            GL.Vertex3(0, 0, 5);
            //Face 3
            GL.Color3(Color.Red);
            GL.Vertex3(5, 0, 0);
            GL.Color3(Color.White);
            GL.Vertex3(0, 2.5, 0);
            GL.Color3(Color.Blue);
            GL.Vertex3(0, 0, -5);
            //Face 4
            GL.Color3(Color.Green);
            GL.Vertex3(-5, 0, 0);
            GL.Color3(Color.White);
            GL.Vertex3(0, 2.5, 0);
            GL.Color3(Color.Blue);
            GL.Vertex3(0, 0, -5);

             GL.End();
            */
            //////////////////////////////////////////////////
            //////////////////////////////////////////////////////////////

            //if (glControl1.Focused)
            //    GL.Color3(Color.Yellow);
            //else
            //    GL.Color3(Color.Blue);
            //GL.Rotate(rotation, Vector3.UnitZ); // OpenTK has this nice Vector3 class!
            //GL.Begin(BeginMode.Triangles);
            //GL.Vertex2(100, 50);
            //GL.Vertex2(200, 20);
            //GL.Vertex2(200, 50);
            //GL.End();

            ///////////////////////////////////////////////////////////////

            glControl1.SwapBuffers();

        }

        void RectJoint_1()
        {         

            float c = 0.4f;

            GL.Rotate(ypr1[0], Vector3.UnitZ);
            GL.Rotate(ypr1[1], Vector3.UnitX);
            GL.Rotate(ypr1[2], Vector3.UnitY);

            GL.Begin(PrimitiveType.Quads);
           
            GL.Color3(Color.Red);
            GL.Vertex3(-c, c, c);
            GL.Vertex3(-c, -c, c);
            GL.Vertex3(5, -c, c);
            GL.Vertex3(5, c, c);

            GL.Color3(Color.Orange);
            GL.Vertex3(-c, c, -c);
            GL.Vertex3(-c, -c, -c);
            GL.Vertex3(5, -c, -c);
            GL.Vertex3(5, c, -c);

            //             
            GL.Color3(Color.Green);
            GL.Vertex3(-c, c, c);
            GL.Vertex3(-c, c, -c);
            GL.Vertex3(5, c, -c);
            GL.Vertex3(5, c, c);
            //           
            GL.Color3(Color.Blue);
            GL.Vertex3(-c, -c, c);
            GL.Vertex3(-c, -c, -c);
            GL.Vertex3(5 , -c, -c);
            GL.Vertex3(5, -c, c);
            //   
            GL.Color3(Color.Yellow);
            GL.Vertex3(-c, c, c);
            GL.Vertex3(-c, -c, c);
            GL.Vertex3(-c, -c, -c);
            GL.Vertex3(-c, c, -c);
            //     
            GL.Color3(Color.Magenta);
            GL.Vertex3(5, c, c);
            GL.Vertex3(5, -c, c);
            GL.Vertex3(5, -c, -c);
            GL.Vertex3(5, c, -c);
           
            GL.End();
        }

        void RectJoint_2()
        {

            float c = 0.4f;

            ///GL.Rotate(ypr2[0] - ypr1[0], new Vector3(5, 5, 1));

            //Matrix4 mat;

            //mat =
            //    Matrix4.CreateTranslation(head.LocalPosition) *
            //    Matrix4.CreateRotationZ(head.Angle + head.Parent.Angle) *
            //    Matrix4.CreateTranslation(head.Parent.Position);
            //head.Position = mat.Row3.Xyz;

            GL.Begin(PrimitiveType.LineLoop);

            GL.Color3(Color.Red);
            GL.Vertex3(5, c, c);
            GL.Vertex3(5, -c, c);
            GL.Vertex3(7 + c, -c, c);
            GL.Vertex3(7 + c, c, c);

            GL.Color3(Color.Orange);
            GL.Vertex3(5, c, -c);
            GL.Vertex3(5, -c, -c);
            GL.Vertex3(7 + c, -c, -c);
            GL.Vertex3(7 + c, c, -c);

            //             
            GL.Color3(Color.Green);
            GL.Vertex3(5, c, c);
            GL.Vertex3(5, c, -c);
            GL.Vertex3(7 + c, c, -c);
            GL.Vertex3(7 + c, c, c);
            //           
            GL.Color3(Color.Blue);
            GL.Vertex3(5, -c, c);
            GL.Vertex3(5, -c, -c);
            GL.Vertex3(7 + c, -c, -c);
            GL.Vertex3(7 + c, -c, c);
            //   
            GL.Color3(Color.Yellow);
            GL.Vertex3(5, c, c);
            GL.Vertex3(5, -c, c);
            GL.Vertex3(5, -c, -c);
            GL.Vertex3(5, c, -c);
            //     
            GL.Color3(Color.Magenta);
            GL.Vertex3(7 + c, c, c);
            GL.Vertex3(7 + c, -c, c);
            GL.Vertex3(7 + c, -c, -c);
            GL.Vertex3(7 + c, c, -c);

            GL.End();
        }

        void RectPoint(double x, double y, double z)
        {
            double c = 0.4f;
            
            GL.Color3(Color.Blue);
            GL.Begin(PrimitiveType.Quads);
                GL.Color3(Color.Red);
                GL.Vertex3(x - c, y + c, z + c); 
                GL.Vertex3(x + c, y + c, z + c); 
                GL.Vertex3(x + c, y - c, z + c); 
                GL.Vertex3(x - c, y - c, z + c);
                //     
                GL.Color3(Color.Orange);
                GL.Vertex3(x - c, y + c, z - c); 
                GL.Vertex3(x + c, y + c, z - c); 
                GL.Vertex3(x + c, y - c, z - c); 
                GL.Vertex3(x - c, y - c, z - c);

                //             
                GL.Color3(Color.Green);
                GL.Vertex3(x - c, y + c, z + c); 
                GL.Vertex3(x + c, y + c, z + c); 
                GL.Vertex3(x + c, y + c, z - c); 
                GL.Vertex3(x - c, y + c, z - c);
                //           
                GL.Color3(Color.Blue);
                GL.Vertex3(x - c, y - c, z + c); 
                GL.Vertex3(x - c, y - c, z - c); 
                GL.Vertex3(x + c, y - c, z - c); 
                GL.Vertex3(x + c, y - c, z + c);
                //   
                GL.Color3(Color.Yellow);
                GL.Vertex3(x + c, y + c, z - c); 
                GL.Vertex3(x + c, y + c, z + c);
                GL.Vertex3(x + c, y - c, z + c); 
                GL.Vertex3(x + c, y - c, z - c);
                //     
                GL.Color3(Color.Magenta);
                GL.Vertex3(x - c, y + c, z - c); 
                GL.Vertex3(x - c, y - c, z - c); 
                GL.Vertex3(x - c, y - c, z + c); 
                GL.Vertex3(x - c, y + c, z + c);
                
            GL.End();

        } /////
        
        private void glControl1_KeyDown(object sender, KeyEventArgs e)
        {
            if (!loaded)
                return;
            if (e.KeyCode == Keys.Space)
            {
                x++;
                glControl1.Invalidate();
            }
        }
       
        private void glControl1_Resize(object sender, EventArgs e)
        {
            SetupViewport();
            glControl1.Invalidate();
        }


        private void btn_openPort_Click(object sender, EventArgs e)
        {
            try
            {
                if (comPort1.Text == "" || Baudrate1.Text == "")
                {
                    MessageBox.Show("Ra kenek, koneksi " + serialPort1.PortName + " gak ono");
                }
                else if (comPort2.Text == "" || Baudrate2.Text == "")
                {
                    MessageBox.Show("Invalid, connection " + serialPort2.PortName + " is disconnect");
                }
                else
                {
                    serialPort1.PortName = comPort1.Text;
                    serialPort1.BaudRate = Convert.ToInt32(Baudrate1.Text);
                    serialPort1.Open();

                    serialPort2.PortName = comPort2.Text;
                    serialPort2.BaudRate = Convert.ToInt32(Baudrate2.Text);
                    serialPort2.Open();

                    if (serialPort1.IsOpen && serialPort2.IsOpen)
                    {
                        btn_openPort.Enabled = false;
                        btn_closePort.Enabled = true;
                        m_sData1.ReadOnly = false;

                        m_sData2.ReadOnly = false;

                    }
                }
            }
            catch (UnauthorizedAccessException)
            {
                MessageBox.Show("Unauthorized Access");
            }
            // m_sData.Text = String.Format("{0}",sFlag);
            
        }
        private void btn_closePort_Click(object sender, EventArgs e)
        {
            if (serialPort1.IsOpen && serialPort2.IsOpen)
            {
                serialPort1.Close();        serialPort2.Close();
                btn_openPort.Enabled = true;
                btn_closePort.Enabled = false;

                m_sData1.ReadOnly = true;
                m_sData1.Clear();

                m_sData2.ReadOnly = true;
                m_sData2.Clear();

                file1.Close();
                file2.Close();
            }
        }

        private void serialPort1_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {
            try
            {
               // sData = serialPort1.ReadExisting();
               //this.Invoke(new EventHandler(DisplayText));                          
                
            }
            catch (TimeoutException) { }
        }

        private void DisplayText(object sender, EventArgs e)
        {
            m_sData1.AppendText(sData);
           
        }

        private void m_sData_KeyPress(object sender, System.Windows.Forms.KeyPressEventArgs e)
        {
            // If the port is closed, don't try to send a character.
            if (!serialPort1.IsOpen && !serialPort1.IsOpen) return;

            // If the port is Open, declare a char[] array with one element.
            char[] buff = new char[1];
            buff[0] = e.KeyChar;   // Load element 0 with the key character.

            serialPort1.Write(buff, 0, 1);
            serialPort2.Write(buff, 0, 1);// Send the one character buffer.
            // Set the KeyPress event as handled so the character won't
            // display locally. If you want it to display, omit the next line.
            e.Handled = true;
           
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            if (serialPort1.IsOpen && serialPort2.IsOpen)
            {
                char[] buf = new char[1];
                buf[0] = 'o';
                serialPort1.Write(buf, 0, 1);
                serialPort2.Write(buf, 0, 1);

                ReadData1();
                ReadData2();
                
                file1.Write(dat1);
                file2.Write(dat2);
               
                //m_sData1.Text = Convert.ToString(ypr[0]);
                //m_sData1.Text = String.Format("ypr1\t{0}\t{1}\t{2}", ypr1[0], ypr1[1], ypr1[2]);
                //m_sData2.Text = String.Format("ypr2\t{0}\t{1}\t{2}", ypr2[0], ypr2[1], ypr2[2]);
            }            
        }
        
        void ReadData1()
        {
            int[] buffer = new int[120];
            int bytes_number = 0;
                   
           
            dat1 = serialPort1.ReadExisting();
            m_sData1.Text = dat1;

         /*
            for (int i = bytes_number; i < bytes_number + serialPort1.BytesToRead; i++)
            {
                buffer[i] = serialPort1.ReadByte();
                bytes_number++;
                if (i >= 119)
                    break;                
            }           
           
            if (bytes_number > 5)
            {
                int max_bytes = bytes_number - 1;
                if (max_bytes > 119) max_bytes = 119;

                for (int i = max_bytes; i >= 8; i--)
                {
                    if (buffer[i - 8] == 254 && buffer[i] == 255)
                    {
                        ID1 = buffer[i - 7];
                        ypr1[0] = buffer[i - 6] * 10 + buffer[i - 5];
                        ypr1[1] = buffer[i - 4] * 10 + buffer[i - 3];
                        ypr1[2] = buffer[i - 2] * 10 + buffer[i - 1];
                    }                    
                    bytes_number = 0;
                    break;
                }
            }   
          */
        }

        void ReadData2()
        {
            int[] buffer = new int[120];
            int bytes_number = 0;

            dat2 = serialPort2.ReadExisting();
            m_sData2.Text = dat2;
           /*
            for (int i = bytes_number; i < bytes_number + serialPort2.BytesToRead; i++)
            {
                buffer[i] = serialPort2.ReadByte();
                bytes_number++;
                if (i >= 119)
                    break;
            }

            if (bytes_number > 5)
            {
                int max_bytes = bytes_number - 1;
                if (max_bytes > 119) max_bytes = 119;

                for (int i = max_bytes; i >= 8; i--)
                {
                    if (buffer[i - 8] == 254 && buffer[i] == 255)
                    {
                        ID2 = buffer[i - 7];
                        ypr2[0] = buffer[i - 6] * 10 + buffer[i - 5];
                        ypr2[1] = buffer[i - 4] * 10 + buffer[i - 3];
                        ypr2[2] = buffer[i - 2] * 10 + buffer[i - 1];
                    }
                    bytes_number = 0;
                    break;
                }
            }
            */
        }

    }
}
