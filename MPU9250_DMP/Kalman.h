#ifndef _KALMAN_H_
#define _KALMAN_H_


class Kalman
{
  public:
      float x_pred, x_pred_last;
      float p_pred, p_pred_last;
  
      float x_corr,p_corr, x_corr_int;
      float K;
  
  public:
      Kalman();
      void Init();
      float Estimate(float input);  
      float EstimateGyro(float gyro[3]); 
    
};

#endif /* _KALMAN_H_ */
