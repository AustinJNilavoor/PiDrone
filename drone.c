#include "pico/stdlib.h"
#include <stdio.h>
#include <string.h>
#include "pico/binary_info.h"
#include "hardware/i2c.h"
#include "hardware/uart.h"

#define CWM_1 12
#define CWM_2 21
#define CCWM_1 3
#define CCWM_2 16

#define SDA_PIN 14
#define SCL_PIN 15

#define TX_PIN 0
#define RX_PIN 1

static int i2c_addr = 0x68;
i2c_inst_t *i2c = i2c1;
int16_t acceleration[3], gyro[3];

static void mpu6050_reset()
{
    uint8_t buf[] = {0x6B, 0x00};
    i2c_write_blocking(i2c, i2c_addr, buf, 2, false);
}

static void mpu6050_read_raw(int16_t accel[3], int16_t gyro[3])
{
    uint8_t buffer[6];
    uint8_t val = 0x3B;

    i2c_write_blocking(i2c, i2c_addr, &val, 1, true);
    i2c_read_blocking(i2c, i2c_addr, buffer, 6, false);
    for (int i = 0; i < 3; i++)
    {
        accel[i] = (buffer[i * 2] << 8 | buffer[(i * 2) + 1]);
    }

    val = 0x43;
    i2c_write_blocking(i2c, i2c_addr, &val, 1, true);
    i2c_read_blocking(i2c, i2c_addr, buffer, 6, false);

    for (int i = 0; i < 3; i++)
    {
        gyro[i] = (buffer[i * 2] << 8 | buffer[(i * 2) + 1]);
    }
}

static void i2c_setup()
{
    i2c_init(i2c, 400 * 1000);
    gpio_set_function(SDA_PIN, GPIO_FUNC_I2C);
    gpio_set_function(SCL_PIN, GPIO_FUNC_I2C);
    gpio_pull_up(SDA_PIN);
    gpio_pull_up(SCL_PIN);
    bi_decl(bi_2pins_with_func(SDA_PIN, SCL_PIN, GPIO_FUNC_I2C));
    mpu6050_reset();
}

static void uart_setup()
{
    uart_init(uart0, 115200);
    gpio_set_function(TX_PIN, GPIO_FUNC_UART);
    gpio_set_function(RX_PIN, GPIO_FUNC_UART);
}

// void on_uart_rx() {
//     while (uart_is_readable(UART_ID)) {
//         uint8_t ch = uart_getc(UART_ID);
//         printf("%c",ch)
//     }
// }

static void uart_read(int8_t data[4]){
    uart_read_blocking(uart0, data, 4);

}

int main()
{
    stdio_init_all();
    i2c_setup();
    uart_setup();
    uint8_t data[4];

    while (1)
    {
        mpu6050_read_raw(acceleration, gyro);
        printf("Acc. X = %d, Y = %d, Z = %d , new\n", acceleration[0], acceleration[1], acceleration[2]);
        printf("Gyro. X = %d, Y = %d, Z = %d\n", gyro[0], gyro[1], gyro[2]);
        // uart_read(data);
        // printf("%d %c",data[0],data[1]);
        sleep_ms(100);
    }
}