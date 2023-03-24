class Filter
{  
   float x_pred, x_pred_last;
   float p_pred, p_pred_last;
  
   float x_corr,p_corr, x_corr_int;
   float K;
    
  Filter()
  {}
  
  float[] LPF(float[] input, float fc, float dt)
  {
    float[] x = new float[3];    
    float[] y = new float[3];
    float[] y_last = new float[3];  
    float RC, alfa;
    
    x=input;
    y_last[0] = 0;    y_last[1] = 0;    y_last[2] = 0;
    
    RC = 1/(2*PI*fc);
    alfa = RC/(RC + dt);
    
    y[0] = alfa * x[0] + ((1 - alfa) * y_last[0]);
    y[1] = alfa * x[1] + ((1 - alfa) * y_last[1]);
    y[2] = alfa * x[2] + ((1 - alfa) * y_last[2]);

    y_last = y;
    
    return y;    
  }
  
   float[] HPF(float[] input, float fc, float dt)
  {
    float[] x = new float[3];
    float[] y = new float[3];
    float[] y_last = new float[3]; 
    float[] x_last = new float[3]; 
    float RC, alfa;
    
    x=input;
    x_last[0] = 0;    x_last[1] = 0;    x_last[2] = 0;
    y_last[0] = 0;    y_last[1] = 0;    y_last[2] = 0;
    
    RC= 1/(2*PI*fc);
    alfa = RC/(RC + dt);
    
    y[0] = alfa *(y_last[0] + x[0]- x_last[0]);
    y[1] = alfa *(y_last[1] + x[1]- x_last[1]);
    y[2] = alfa *(y_last[2] + x[2]- x_last[2]);
    
    y_last = y;    
    x_last = x;
    
    return y;    
  }
  
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
