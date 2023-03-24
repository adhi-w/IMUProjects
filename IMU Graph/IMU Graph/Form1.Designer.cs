namespace IMU_Graph
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.glControl1 = new OpenTK.GLControl();
            this.serialPort1 = new System.IO.Ports.SerialPort(this.components);
            this.comPort1 = new System.Windows.Forms.ComboBox();
            this.Baudrate1 = new System.Windows.Forms.ComboBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.btn_openPort = new System.Windows.Forms.Button();
            this.m_sData1 = new System.Windows.Forms.TextBox();
            this.btn_closePort = new System.Windows.Forms.Button();
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.label3 = new System.Windows.Forms.Label();
            this.serialPort2 = new System.IO.Ports.SerialPort(this.components);
            this.label4 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.Baudrate2 = new System.Windows.Forms.ComboBox();
            this.comPort2 = new System.Windows.Forms.ComboBox();
            this.m_sData2 = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // glControl1
            // 
            this.glControl1.BackColor = System.Drawing.Color.Black;
            this.glControl1.Location = new System.Drawing.Point(12, 12);
            this.glControl1.Name = "glControl1";
            this.glControl1.Size = new System.Drawing.Size(480, 320);
            this.glControl1.TabIndex = 0;
            this.glControl1.VSync = false;
            this.glControl1.Load += new System.EventHandler(this.glControl1_Load);
            this.glControl1.Paint += new System.Windows.Forms.PaintEventHandler(this.glControl1_Paint);
            this.glControl1.KeyDown += new System.Windows.Forms.KeyEventHandler(this.glControl1_KeyDown);
            this.glControl1.Resize += new System.EventHandler(this.glControl1_Resize);
            // 
            // serialPort1
            // 
            this.serialPort1.DataReceived += new System.IO.Ports.SerialDataReceivedEventHandler(this.serialPort1_DataReceived);
            // 
            // comPort1
            // 
            this.comPort1.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comPort1.FormattingEnabled = true;
            this.comPort1.Location = new System.Drawing.Point(498, 35);
            this.comPort1.Name = "comPort1";
            this.comPort1.Size = new System.Drawing.Size(121, 21);
            this.comPort1.TabIndex = 1;
            // 
            // Baudrate1
            // 
            this.Baudrate1.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.Baudrate1.FormattingEnabled = true;
            this.Baudrate1.Items.AddRange(new object[] {
            "9600",
            "19200",
            "38400",
            "115200"});
            this.Baudrate1.Location = new System.Drawing.Point(498, 84);
            this.Baudrate1.Name = "Baudrate1";
            this.Baudrate1.Size = new System.Drawing.Size(121, 21);
            this.Baudrate1.TabIndex = 2;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(498, 17);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(64, 13);
            this.label1.TabIndex = 3;
            this.label1.Text = "Serial Port 1";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(499, 67);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(59, 13);
            this.label2.TabIndex = 4;
            this.label2.Text = "Baudrate 1";
            // 
            // btn_openPort
            // 
            this.btn_openPort.Location = new System.Drawing.Point(513, 140);
            this.btn_openPort.Name = "btn_openPort";
            this.btn_openPort.Size = new System.Drawing.Size(96, 43);
            this.btn_openPort.TabIndex = 5;
            this.btn_openPort.Text = "Connect";
            this.btn_openPort.UseVisualStyleBackColor = true;
            this.btn_openPort.Click += new System.EventHandler(this.btn_openPort_Click);
            // 
            // m_sData1
            // 
            this.m_sData1.Location = new System.Drawing.Point(12, 349);
            this.m_sData1.Multiline = true;
            this.m_sData1.Name = "m_sData1";
            this.m_sData1.Size = new System.Drawing.Size(324, 26);
            this.m_sData1.TabIndex = 6;
            this.m_sData1.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.m_sData_KeyPress);
            // 
            // btn_closePort
            // 
            this.btn_closePort.Location = new System.Drawing.Point(643, 140);
            this.btn_closePort.Name = "btn_closePort";
            this.btn_closePort.Size = new System.Drawing.Size(96, 43);
            this.btn_closePort.TabIndex = 7;
            this.btn_closePort.Text = "Disconnect";
            this.btn_closePort.UseVisualStyleBackColor = true;
            this.btn_closePort.Click += new System.EventHandler(this.btn_closePort_Click);
            // 
            // timer1
            // 
            this.timer1.Enabled = true;
            this.timer1.Interval = 1;
            this.timer1.Tick += new System.EventHandler(this.timer1_Tick);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(9, 414);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(35, 13);
            this.label3.TabIndex = 9;
            this.label3.Text = "label3";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(644, 66);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(59, 13);
            this.label4.TabIndex = 13;
            this.label4.Text = "Baudrate 2";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(643, 16);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(64, 13);
            this.label5.TabIndex = 12;
            this.label5.Text = "Serial Port 2";
            // 
            // Baudrate2
            // 
            this.Baudrate2.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.Baudrate2.FormattingEnabled = true;
            this.Baudrate2.Items.AddRange(new object[] {
            "9600",
            "19200",
            "38400",
            "115200"});
            this.Baudrate2.Location = new System.Drawing.Point(643, 83);
            this.Baudrate2.Name = "Baudrate2";
            this.Baudrate2.Size = new System.Drawing.Size(121, 21);
            this.Baudrate2.TabIndex = 11;
            // 
            // comPort2
            // 
            this.comPort2.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comPort2.FormattingEnabled = true;
            this.comPort2.Location = new System.Drawing.Point(643, 34);
            this.comPort2.Name = "comPort2";
            this.comPort2.Size = new System.Drawing.Size(121, 21);
            this.comPort2.TabIndex = 10;
            // 
            // m_sData2
            // 
            this.m_sData2.Location = new System.Drawing.Point(12, 381);
            this.m_sData2.Multiline = true;
            this.m_sData2.Name = "m_sData2";
            this.m_sData2.Size = new System.Drawing.Size(324, 26);
            this.m_sData2.TabIndex = 14;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(779, 474);
            this.Controls.Add(this.m_sData2);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.Baudrate2);
            this.Controls.Add(this.comPort2);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.btn_closePort);
            this.Controls.Add(this.m_sData1);
            this.Controls.Add(this.btn_openPort);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.Baudrate1);
            this.Controls.Add(this.comPort1);
            this.Controls.Add(this.glControl1);
            this.Name = "Form1";
            this.Text = "Form1";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.Form1_FormClosing);
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private OpenTK.GLControl glControl1;
        private System.IO.Ports.SerialPort serialPort1;
        private System.Windows.Forms.ComboBox comPort1;
        private System.Windows.Forms.ComboBox Baudrate1;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button btn_openPort;
        private System.Windows.Forms.TextBox m_sData1;
        private System.Windows.Forms.Button btn_closePort;
        private System.Windows.Forms.Timer timer1;
        private System.Windows.Forms.Label label3;
        private System.IO.Ports.SerialPort serialPort2;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.ComboBox Baudrate2;
        private System.Windows.Forms.ComboBox comPort2;
        private System.Windows.Forms.TextBox m_sData2;
    }
}

