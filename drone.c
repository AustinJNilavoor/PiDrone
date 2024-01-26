#include <stdio.h>
#include "pico/stdlib.h"
#include "hardware/i2c.h"
#include "pico/binary_info.h"
#include "hardware/uart.h"

#define CWM_1 12
#define CWM_2 21
#define CCWM_1 3
#define CCWM_2 16

#define SDA_PIN 14
#define SCL_PIN 15

#define UART_ID uart0
#define BAUD_RATE 115200

#define UART_TX_PIN 0
#define UART_RX_PIN 1

#define I2C_ID i2c1
#define I2C_ADDR 0x68

int16_t acceleration[3], gyro[3];

uint8_t ch;
static void on_uart_rx()
{
    uint8_t buff[14];
printf("start");
        if (uart_is_readable(UART_ID))
        {
            uart_read_blocking 	(UART_ID,buff,13);
        }
        buff[13] = '\n';
    // ch = uart_getc(UART_ID);
    printf("%s", buff);
    printf("stp");
}

static void mpu6050_reset()
{
    uint8_t buf[] = {0x6B, 0x00};
    i2c_write_blocking(I2C_ID, I2C_ADDR, buf, 2, false);
}

static void mpu6050_read_raw(int16_t accel[3], int16_t gyro[3])
{
    uint8_t buffer[6];
    uint8_t val = 0x3B;

    i2c_write_blocking(I2C_ID, I2C_ADDR, &val, 1, true);
    i2c_read_blocking(I2C_ID, I2C_ADDR, buffer, 6, false);
    for (int i = 0; i < 3; i++)
    {
        accel[i] = (buffer[i * 2] << 8 | buffer[(i * 2) + 1]);
    }

    val = 0x43;
    i2c_write_blocking(I2C_ID, I2C_ADDR, &val, 1, true);
    i2c_read_blocking(I2C_ID, I2C_ADDR, buffer, 6, false);

    for (int i = 0; i < 3; i++)
    {
        gyro[i] = (buffer[i * 2] << 8 | buffer[(i * 2) + 1]);
    }
}

static void i2c_setup()
{
    i2c_init(I2C_ID, 400 * 1000);
    gpio_set_function(SDA_PIN, GPIO_FUNC_I2C);
    gpio_set_function(SCL_PIN, GPIO_FUNC_I2C);
    gpio_pull_up(SDA_PIN);
    gpio_pull_up(SCL_PIN);
    bi_decl(bi_2pins_with_func(SDA_PIN, SCL_PIN, GPIO_FUNC_I2C));
    mpu6050_reset();
}

static void uart_setup()
{
    uart_init(UART_ID, BAUD_RATE);
    gpio_set_function(UART_TX_PIN, GPIO_FUNC_UART);
    gpio_set_function(UART_RX_PIN, GPIO_FUNC_UART);
    irq_set_exclusive_handler(UART0_IRQ, on_uart_rx);
    irq_set_enabled(UART0_IRQ, true);
    uart_set_irq_enables(UART_ID, true, false);
}

int main()
{
    stdio_init_all();
    i2c_setup();
    uart_setup();
    while (1)
    {
        // mpu6050_read_raw(acceleration, gyro);
        // printf("Acc. X = %d, Y = %d, Z = %d\n", acceleration[0], acceleration[1], acceleration[2]);
        // printf("Gyro. X = %d, Y = %d, Z = %d\n", gyro[0], gyro[1], gyro[2]);
        sleep_us(100);
    }
}