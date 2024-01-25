#include "pico/stdlib.h"
#include <stdio.h>
#include <string.h>
#include "pico/binary_info.h"
#include "hardware/i2c.h"

#define CWM_1 12
#define CWM_2 21
#define CCWM_1 3
#define CCWM_2 16

#define I2C_SDA_PIN 14
#define I2C_SCL_PIN 15


static int i2c_addr = 0x68;

i2c_inst_t *i2c = i2c1;

static void mpu6050_reset()
{
    uint8_t buf[] = {0x6B, 0x80};
    i2c_write_blocking(i2c, i2c_addr, buf, 2, false);
}

static void mpu6050_read_raw(int16_t accel[3], int16_t gyro[3], int16_t *temp)
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
    val = 0x41;
    i2c_write_blocking(i2c, i2c_addr, &val, 1, true);
    i2c_read_blocking(i2c, i2c_addr, buffer, 2, false);  // False - finished with bus
    
    *temp = buffer[0] << 8 | buffer[1];
}

int main()
{
    stdio_init_all();
    sleep_ms(1000);
    i2c_init(i2c, 400 * 1000);
    gpio_set_function(I2C_SDA_PIN, GPIO_FUNC_I2C);
    gpio_set_function(I2C_SCL_PIN, GPIO_FUNC_I2C);
    gpio_pull_up(I2C_SDA_PIN);
    gpio_pull_up(I2C_SCL_PIN);
    bi_decl(bi_2pins_with_func(I2C_SDA_PIN, I2C_SCL_PIN, GPIO_FUNC_I2C));
    mpu6050_reset();
    int16_t acceleration[3], gyro[3], temp;

    while (1)
    {
        mpu6050_read_raw(acceleration, gyro, &temp);
        printf("Acc. X = %d, Y = %d, Z = %d , new\n", acceleration[0], acceleration[1], acceleration[2]);
        printf("Gyro. X = %d, Y = %d, Z = %d\n", gyro[0], gyro[1], gyro[2]);
        printf("Temp. = %f\n", (temp / 340.0) + 36.53);

        sleep_ms(100);
    }
}