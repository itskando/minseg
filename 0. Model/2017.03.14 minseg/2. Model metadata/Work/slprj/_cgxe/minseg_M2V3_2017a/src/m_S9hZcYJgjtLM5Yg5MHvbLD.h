#ifndef __S9hZcYJgjtLM5Yg5MHvbLD_h__
#define __S9hZcYJgjtLM5Yg5MHvbLD_h__

/* Include files */
#include "simstruc.h"
#include "rtwtypes.h"
#include "multiword_types.h"
#include "slexec_vm_zc_functions.h"

/* Type Definitions */
#ifndef typedef_soHMC5883L
#define typedef_soHMC5883L

typedef struct {
  int32_T isInitialized;
} soHMC5883L;

#endif                                 /*typedef_soHMC5883L*/

#ifndef typedef_InstanceStruct_S9hZcYJgjtLM5Yg5MHvbLD
#define typedef_InstanceStruct_S9hZcYJgjtLM5Yg5MHvbLD

typedef struct {
  SimStruct *S;
  soHMC5883L sysobj;
  boolean_T sysobj_not_empty;
  void *emlrtRootTLSGlobal;
  real32_T *b_y0;
  real32_T *b_y1;
  real32_T *y2;
  covrtInstance *covInst_CONTAINER_BLOCK_INDEX;
} InstanceStruct_S9hZcYJgjtLM5Yg5MHvbLD;

#endif                                 /*typedef_InstanceStruct_S9hZcYJgjtLM5Yg5MHvbLD*/

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */

/* Function Definitions */
extern void method_dispatcher_S9hZcYJgjtLM5Yg5MHvbLD(SimStruct *S, int_T method,
  void* data);

#endif
