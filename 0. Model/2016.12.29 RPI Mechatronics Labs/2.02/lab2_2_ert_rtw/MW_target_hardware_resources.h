#ifndef PORTABLE_WORDSIZES
#ifdef __MW_TARGET_USE_HARDWARE_RESOURCES_H__
#ifndef __MW_TARGET_HARDWARE_RESOURCES_H__
#define __MW_TARGET_HARDWARE_RESOURCES_H__

#include "MW_ArduinoHWInit.h"
#include "arduinoAVRScheduler.h"

#define MW_USECODERTARGET 1
#define MW_TARGETHARDWARE Arduino Mega 2560
#define MW_CONNECTIONINFO_SERIAL_BAUDRATE 115200
#define MW_CONNECTIONINFO_SERIAL_COMPORT codertarget.arduinobase.internal.getExternalModeMexArgs('Serial')
#define MW_CONNECTIONINFO_SERIAL_VERBOSE 0
#define MW_CONNECTIONINFO_TCPIP_IPADDRESS codertarget.arduinobase.internal.getExternalModeMexArgs('Ethernet')
#define MW_CONNECTIONINFO_TCPIP_PORT 17725
#define MW_CONNECTIONINFO_TCPIP_VERBOSE 0
#define MW_CONNECTIONINFO_WIFI_IPADDRESS codertarget.arduinobase.internal.getExternalModeMexArgs('Wifi')
#define MW_CONNECTIONINFO_WIFI_PORT 17725
#define MW_CONNECTIONINFO_WIFI_VERBOSE 0
#define MW_EXTMODE_CONFIGURATION Serial
#define MW_EXTMODE_RUNNING on
#define MW_RTOS Baremetal
#define MW_SCHEDULER_INTERRUPT_SOURCE 0
#define MW_RUNTIME_BUILDACTION 1
#define MW_HOSTCOMPORT_SET_HOST_COM_PORT 1
#define MW_HOSTCOMPORT_COM_PORT_NUMBER /dev/tty.usbmodem621
#define MW_OVERRUNDETECTION_ENABLE_OVERRUN_DETECTION 0
#define MW_OVERRUNDETECTION_DIGITAL_OUTPUT_TO_SET_ON_OVERRUN 13
#define MW_ANALOGINREFVOLTAGE_ANALOG_INPUT_REFERENCE_VOLTAGE 0.000000
#define MW_SERIAL_SERIAL0_BAUD_RATE 4
#define MW_SERIAL_SERIAL1_BAUD_RATE 4
#define MW_SERIAL_SERIAL2_BAUD_RATE 4
#define MW_SERIAL_SERIAL3_BAUD_RATE 4
#define MW_SPI_SPI_CLOCK_OUT_FREQUENCY 1
#define MW_SPI_SPI_MODE 0
#define MW_SPI_SPI_BITORDER 0
#define MW_ETHERNET_LOCAL_IP_ADDRESS 192.168.0.20
#define MW_ETHERNET_LOCAL_MAC_ADDRESS DE:AD:BE:EF:FE:ED
#define MW_WIFI_WIFI_IP_ADDRESS 192.168.1.20
#define MW_WIFI_WIFI_SSID yourNetwork
#define MW_WIFI_SET_WIFI_ENCRYPTION 0
#define MW_WIFI_WIFI_WEP_KEY D0D0DEADF00DABBADEAFBEADED
#define MW_WIFI_WIFI_WEP_KEY_INDEX 0
#define MW_WIFI_WIFI_WPA_PASSWORD secretPassword
#define MW_MULTI_TASKING_MODE 1

#endif /* __MW_TARGET_HARDWARE_RESOURCES_H__ */

#endif

#endif
