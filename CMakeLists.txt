cmake_minimum_required(VERSION 3.12)

# PULL SDK
include(pico_sdk_import.cmake)

project(blink C CXX ASM)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

set(PICO_EXAMBLES_PATH ${/home/austin/pico-examples})

#INIT SDK
pico_sdk_init()

add_executable(drone
	drone.c
	)
	
#PULL PICO STDLIB
target_link_libraries(drone pico_stdlib hardware_i2c hardware_uart)

pico_enable_stdio_usb(drone 1)
pico_enable_stdio_uart(drone 1)
# create u2f
pico_add_extra_outputs(drone) 
