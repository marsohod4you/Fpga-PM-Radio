# Fpga-PM-Radio
Implement Phase Modulation Radio Transmitter in FPGA Altera MAX10, with Marsohod3bis FPGA board.

This is just-for-fan FPGA project which really transmits Phase-Modulated Radio signal from FPGA.
Just 2 FPGA digital output pins used as output for antena: use two short wires each about 0,7 meter. 
These two wires will form 1/4 wave length vibrator.

Do not hate me for digital signal coming directly to "antena" wires without any output filter. Lets hope "antena" is kind of filter itself.

Audio signal is coming to FPGA board as serial data with baud rate 230400 bod.
Audio format: Mono, 22050, 8 bit unsigned samples.
Assuming each byte has start bit, and 2 stop bits we get 230400/11=20945 samples/second. So-so it is close to standard 22050.
Use Audacity app to prepare any audio with this desired format.

Phase modulation is implemented with dynamic PLL phase shift in FPGA.
PLL has 2 clocks each 100MHz output. First used for logic and second has floating phase for radio output.
So each new audio sample received from serial port it causes dynamic phase shift on clock c1 of FPGA PLL.

Listen radio usign mobile phone FM radio receiver.

Yes, Phase modulation really is not pure FM (frequency modulation).
But by nature, shifting phase causes instant frequency change. So PM and FM are very close but related each other via integral/differential.
By the way derivative from sin(x) is cos(x).

This makes possible to use Phase modulation but listen on FM radio.

Full project description can be found at https://marsohod.org/projects/proekty-dlya-platy-marsokhod3/349-pm-radio-transmitter
