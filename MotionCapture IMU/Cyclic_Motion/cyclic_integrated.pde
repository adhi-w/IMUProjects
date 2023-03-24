float dt, sampleFreq;

float[] worldAccel = new float[3];   
float[] linearVelocity = new float[3];
float[] HPF_Velocity = new float[3];

float[] linearPosition = new float[3];
float[] HPF_Position = new float[3];

float[] last_linVel = new float[3];
float[] last_linPos = new float[3];

//////////------For Velocity
float[] x_last_v = new float[3];
float[] y_last_v = new float[3];

//////////-------For Position
float[] x_last_p = new float[3];
float[] y_last_p = new float[3];

float[] sum= new float[3];
float[] sum_p= new float[3];
float N=10;


void CyclicMotion()
{  
  
  //dt = 1000/freq ;
  sampleFreq = freq;

  sum[0]=0;     
  sum[1]=0;     
  sum[2]=0;

  for (int i=1; i<=N; i++)
  {
    sum[0]=sum[0]+(acc[0]*9.8);    // Put Acc input here
    sum[1]=sum[1]+(acc[1]*9.8);
    sum[2]=sum[2]+(acc[2]*9.8);
  }

  worldAccel[0] = sum[0]/N;
  worldAccel[1] = sum[1]/N;
  worldAccel[2] = sum[2]/N;

  getPosition();
}

void getPosition()
{    

  // Get Linear velocity (Integrate Acceleration)   
  linearVelocity[0] = last_linVel[0] + worldAccel[0] * freq;
  linearVelocity[1] = last_linVel[1] + worldAccel[1] * freq;   
  linearVelocity[2] = last_linVel[2] + worldAccel[2] * freq;  

  last_linVel[0] = linearVelocity[0];
  last_linVel[1] = linearVelocity[1]; 
  last_linVel[2] = linearVelocity[2];      

  // HPF Linear Velocity --> Removing drift
  HPF_Velocity = HPF_V(linearVelocity, 0.02, freq);

  linearPosition[0] = last_linPos[0] + HPF_Velocity[0] * freq;   
  linearPosition[1] = last_linPos[1] + HPF_Velocity[1] * freq;  
  linearPosition[2] = last_linPos[2] + HPF_Velocity[2] * freq; 
  
  last_linPos[0] = linearPosition[0];
  last_linPos[1] = linearPosition[1];
  last_linPos[2] = linearPosition[2];

  HPF_Position = HPF_P(linearPosition, 0.02, freq);
  
  sum_p[0]=0;  sum_p[1]=0;  sum_p[2]=0;
//  
//    for (int i=1; i<=20; i++)
//  {
//    sum_p[0]=sum_p[0]+HPF_Position[0];    // Put Acc input here
//    sum_p[1]=sum_p[1]+HPF_Position[1];
//    sum_p[2]=sum_p[2]+HPF_Position[2];
//  }
//
//  HPF_Position[0] = sum_p[0]/20;
//  HPF_Position[1] = sum_p[1]/20;
//  HPF_Position[2] = sum_p[2]/20;

}

// High Pass Filter-->Velocity
float[] HPF_V(float[] input, float fc, float dt)
{
  float[] x = new float[3];          
  float[] y = new float[3];


  float RC, alfa;

  x[0]=input[0];    
  x[1]=input[1];      
  x[2]=input[2];

  RC= 1/(2*PI*fc);
  alfa = RC/(RC + dt);

  y[0] = alfa *(y_last_v[0] + x[0]- x_last_v[0]);
  y[1] = alfa *(y_last_v[1] + x[1]- x_last_v[1]);
  y[2] = alfa *(y_last_v[2] + x[2]- x_last_v[2]);

  y_last_v[0] = y[0];    
  y_last_v[1] = y[1];     
  y_last_v[2] = y[2];    
  
  x_last_v[0] = x[0];    
  x_last_v[1] = x[1];     
  x_last_v[2] = x[2];

  return y;
}

// High Pass Filter-->Position
float[] HPF_P(float[] input, float fc, float dt)
{
  float[] x = new float[3];          
  float[] y = new float[3];


  float RC, alfa;

  x[0]=input[0];    
  x[1]=input[1];      
  x[2]=input[2];

  RC= 1/(2*PI*fc);
  alfa = RC/(RC + dt);

  y[0] = alfa *(y_last_p[0] + x[0]- x_last_p[0]);
  y[1] = alfa *(y_last_p[1] + x[1]- x_last_p[1]);
  y[2] = alfa *(y_last_p[2] + x[2]- x_last_p[2]);

  y_last_p[0] = y[0];    
  y_last_p[1] = y[1];     
  y_last_p[2] = y[2];    
  
  x_last_p[0] = x[0];    
  x_last_p[1] = x[1];     
  x_last_p[2] = x[2];

  return y;
}

// Low Pass Filter
float LPF(float input, float fc, float dt)
{
  float x = input;

  float RC, alfa;
  float y;
  float y_last = 0;

  RC = 1/(2*PI*fc);
  alfa = RC/(RC + dt);

  y = alfa * x + ((1 - alfa) * y_last);

  y_last = y;

  return y;
}

float x_pred, x_pred_last;
float p_pred, p_pred_last;

float x_corr, p_corr, x_corr_int;
float K;

float Kalman_Estimate(float input)
{
  float A = 1;    
  float H = 1;
  float P = 1;    
  float Q = 0.1;
  float R = 4;

  //prediction update
  x_pred = A * x_pred_last;
  p_pred = p_pred_last + Q;

  //measurement update
  K = p_pred * H / (H * H * p_pred + R);
  x_corr = x_pred + K * (input - H * x_pred);
  p_corr = (1 - K * H) * p_pred;

  x_corr_int = (x_corr+x_pred_last)/2;

  x_pred_last = x_corr;
  p_pred_last = p_corr;  

  return x_corr_int;
}

