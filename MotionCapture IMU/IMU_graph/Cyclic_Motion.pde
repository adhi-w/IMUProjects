class CyclicMotion
{
  float[] q = new float[4];
  float[] realAccel = new float[3]; 
  float[] gyro = new float[3];  
  
  float sampleFreq;
  
  float[] gravity = new float[3];
  
  float[] linearAccel = new float[3];  
  
  float[] linearVelocity = new float[3];
  float[] HPF_Velocity = new float[3];
  float[] LPF_Velocity = new float[3];
  
  float[] linearPosition = new float[3];
  float[] HPF_Position = new float[3];
  float[] LPF_Position = new float[3];
  
  CyclicMotion(float[] quat, float[] acc, float[] gyroscope, float freq)
  {
      q = quat;
      realAccel = acc;
      gyro = gyroscope;
      sampleFreq = freq;
      
      getPosition();
  }
  
  void getGravity()
  {
    gravity[0] = 2 * (q[1]*q[3] - q[0]*q[2]);
    gravity[1] = 2 * (q[0]*q[1] + q[2]*q[3]);
    gravity[2] = q[0]*q[0] - q[1]*q[1] - q[2]*q[2] + q[3]*q[3];    
  }
  
  void getPosition()
  {
    float[] last_linVel = new float[3];
    float[] last_linPos = new float[3];
    
    getGravity();
    
    // Get Linear Acc (no gravity)
    for(int i=0; i<=2; i++)
    {
        linearAccel[i] = realAccel[i] - (gravity[i] * 4096);    
    }
    
    // Get Linear velocity (Integrate Acceleration) 
    for(int i=0; i<=2; i++)
    {   
        linearVelocity[i] = last_linVel[i] + linearAccel[i] * sampleFreq;       
        last_linVel[i] = linearVelocity[i];
    }
    
    // HPF Linear Velocity --> Removing drift
    for(int i=0; i<=2; i++)
    {
        HPF_Velocity[i] = HPF(linearVelocity[i], 0.4, sampleFreq); //sampleFreq
        //HPF_Velocity[i] = Kalman_Estimate(HPF_Velocity[i]);
    }  
    
    // Get Linear position (Integrate Velocity) 
    for(int i=0; i<=2; i++)
    { 
        linearPosition[i] = last_linPos[i] + HPF_Velocity[i] * sampleFreq;  
        last_linPos[i] = linearPosition[i];
    }
    
    // HPF Linear Position --> Removing drift
     for(int i=0; i<=2; i++)
    {   
        HPF_Position[i] = HPF(linearPosition[i], 0.4, sampleFreq);
       HPF_Position[i] =  Kalman_Estimate(HPF_Position[i]); 
    }
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
  
  // High Pass Filter
    float HPF(float input, float fc, float dt)
  {
    float x = input;
    
    float RC, alfa;
    float y;
    float y_last = 0;
    float x_last = 0;
    
    RC= 1/(2*PI*fc);
    alfa = RC/(RC + dt);
    
    y = alfa *(y_last + x- x_last);
    
    y_last = y;    
    x_last = x;
    
    return y;    
  }
  
    float x_pred, x_pred_last;
    float p_pred, p_pred_last;
  
    float x_corr,p_corr, x_corr_int;
    float K;
      
  float Kalman_Estimate(float input)
  {
    float A = 1;    
    float H = 1;
    float P = 1;    
    float Q = 4;
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
}
