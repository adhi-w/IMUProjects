#include "Kalman.h"
#include "math.h"

#define A 1
#define H 1
#define P 1

#define Q 0.1
#define R 4

Kalman::Kalman()
{

  
}
float Kalman::Estimate(float input)
{
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

float Kalman::EstimateGyro(float gyro[3])
{     
    //prediction update
        x_pred = A * x_pred_last;
        p_pred = p_pred_last + Q;
        
        //measurement update
        K = p_pred * H / (H * H * p_pred + R);
        x_corr = x_pred + K * (gyro[0] - H * x_pred);
        p_corr = (1 - K * H) * p_pred;
        
        x_corr_int = (x_corr+x_pred_last)/2;
        
        x_pred_last = x_corr;
        p_pred_last = p_corr;  
        
   return x_corr_int;
}
