/*
 * File: lab5.h
 *
 * Code generated for Simulink model 'lab5'.
 *
 * Model version                  : 1.5
 * Simulink Coder version         : 8.9 (R2015b) 13-Aug-2015
 * C/C++ source code generated on : Tue Mar 21 17:31:11 2017
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: Atmel->AVR
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#ifndef RTW_HEADER_lab5_h_
#define RTW_HEADER_lab5_h_
#include <stddef.h>
#include <string.h>
#ifndef lab5_COMMON_INCLUDES_
# define lab5_COMMON_INCLUDES_
#include "rtwtypes.h"
#include "rtw_continuous.h"
#include "rtw_solver.h"
#include "arduino_serialwrite_lct.h"
#endif                                 /* lab5_COMMON_INCLUDES_ */

#include "lab5_types.h"
#include "MW_target_hardware_resources.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

/* Block states (auto storage) for system '<Root>' */
typedef struct {
  uint8_T Output_DSTATE;               /* '<S1>/Output' */
} DW_lab5_T;

/* Parameters (auto storage) */
struct P_lab5_T_ {
  uint8_T CounterLimited_uplimit;      /* Mask Parameter: CounterLimited_uplimit
                                        * Referenced by: '<S3>/FixPt Switch'
                                        */
  uint32_T SerialTransmit_p1;          /* Computed Parameter: SerialTransmit_p1
                                        * Referenced by: '<Root>/Serial Transmit'
                                        */
  uint8_T Constant_Value;              /* Computed Parameter: Constant_Value
                                        * Referenced by: '<S3>/Constant'
                                        */
  uint8_T Output_InitialCondition;     /* Computed Parameter: Output_InitialCondition
                                        * Referenced by: '<S1>/Output'
                                        */
  uint8_T FixPtConstant_Value;         /* Computed Parameter: FixPtConstant_Value
                                        * Referenced by: '<S2>/FixPt Constant'
                                        */
};

/* Real-time Model Data Structure */
struct tag_RTM_lab5_T {
  const char_T * volatile errorStatus;
};

/* Block parameters (auto storage) */
extern P_lab5_T lab5_P;

/* Block states (auto storage) */
extern DW_lab5_T lab5_DW;

/* Model entry point functions */
extern void lab5_initialize(void);
extern void lab5_step(void);
extern void lab5_terminate(void);

/* Real-time Model object */
extern RT_MODEL_lab5_T *const lab5_M;

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'lab5'
 * '<S1>'   : 'lab5/Counter Limited'
 * '<S2>'   : 'lab5/Counter Limited/Increment Real World'
 * '<S3>'   : 'lab5/Counter Limited/Wrap To Zero'
 */
#endif                                 /* RTW_HEADER_lab5_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
