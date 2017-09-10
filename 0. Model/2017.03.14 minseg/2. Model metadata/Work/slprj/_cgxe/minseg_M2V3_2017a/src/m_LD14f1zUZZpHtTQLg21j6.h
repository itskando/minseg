#ifndef __LD14f1zUZZpHtTQLg21j6_h__
#define __LD14f1zUZZpHtTQLg21j6_h__

/* Include files */
#include "simstruc.h"
#include "rtwtypes.h"
#include "multiword_types.h"
#include "slexec_vm_zc_functions.h"

/* Type Definitions */
#ifndef typedef_soMPU6050Temp
#define typedef_soMPU6050Temp

typedef struct {
  int32_T isInitialized;
} soMPU6050Temp;

#endif                                 /*typedef_soMPU6050Temp*/

#ifndef typedef_InstanceStruct_LD14f1zUZZpHtTQLg21j6
#define typedef_InstanceStruct_LD14f1zUZZpHtTQLg21j6

typedef struct {
  SimStruct *S;
  soMPU6050Temp sysobj;
  boolean_T sysobj_not_empty;
  void *emlrtRootTLSGlobal;
  int16_T *b_y0;
  covrtInstance *covInst_CONTAINER_BLOCK_INDEX;
} InstanceStruct_LD14f1zUZZpHtTQLg21j6;

#endif                                 /*typedef_InstanceStruct_LD14f1zUZZpHtTQLg21j6*/

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */

/* Function Definitions */
extern void method_dispatcher_LD14f1zUZZpHtTQLg21j6(SimStruct *S, int_T method,
  void* data);

#endif
