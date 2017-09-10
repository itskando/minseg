/* Include files */

#include "minseg_M2V3_2017a_cgxe.h"
#include "m_boITqx5yvm32bVg0QmvBBH.h"
#include "m_LD14f1zUZZpHtTQLg21j6.h"
#include "m_S9hZcYJgjtLM5Yg5MHvbLD.h"
#include "m_0q9lZWm65339Jv4e8zasUF.h"

unsigned int cgxe_minseg_M2V3_2017a_method_dispatcher(SimStruct* S, int_T method,
  void* data)
{
  if (ssGetChecksum0(S) == 484678332 &&
      ssGetChecksum1(S) == 2273987662 &&
      ssGetChecksum2(S) == 188570917 &&
      ssGetChecksum3(S) == 550155842) {
    method_dispatcher_boITqx5yvm32bVg0QmvBBH(S, method, data);
    return 1;
  }

  if (ssGetChecksum0(S) == 1766515872 &&
      ssGetChecksum1(S) == 266315462 &&
      ssGetChecksum2(S) == 147370359 &&
      ssGetChecksum3(S) == 2321725221) {
    method_dispatcher_LD14f1zUZZpHtTQLg21j6(S, method, data);
    return 1;
  }

  if (ssGetChecksum0(S) == 2296784034 &&
      ssGetChecksum1(S) == 1490608825 &&
      ssGetChecksum2(S) == 960131213 &&
      ssGetChecksum3(S) == 927089846) {
    method_dispatcher_S9hZcYJgjtLM5Yg5MHvbLD(S, method, data);
    return 1;
  }

  if (ssGetChecksum0(S) == 4107914026 &&
      ssGetChecksum1(S) == 3666773936 &&
      ssGetChecksum2(S) == 2628108230 &&
      ssGetChecksum3(S) == 3796599614) {
    method_dispatcher_0q9lZWm65339Jv4e8zasUF(S, method, data);
    return 1;
  }

  return 0;
}
