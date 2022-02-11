# VLSI-Verification
TBD

reg8_defected

The verification test of this component has covered:
 - no operation invoked (control register is equal to 0):
    outputs were unchanged: PASS!

 - single invoke of all operations (appropriate control bit is set; every operation has its own control bit written next to operation bellow):

    CLEAR[0]: FAIL! Clean do not load value 8'h00, instead it loads value 8'h01. One verification block for representation:
    ```
    # expected {msb = 0, out = 00000000, lsb = 0}
    #  != got  {msb = 0, out = 00000001, lsb = 0}
    ```
    LOAD[1]: PASS!
    INC[2]: FAIL! Inc operation does not increment value for 1, instead it decrements it. Three successive blocks for representation:
    ```
    #  expected {msb = 0, out = 10011101, lsb = 0} // initial state
    #  == got   {msb = 0, out = 10011101, lsb = 0} // initial state
    ```
    ```
    #  expected {msb = 0, out = 10011110, lsb = 0} // + 1
    #  != got   {msb = 0, out = 10011100, lsb = 0} // - 1
    ```
    ```
    #  expected {msb = 0, out = 10011111, lsb = 0} // + 1
    #  != got   {msb = 0, out = 10011011, lsb = 0} // - 1
    ```
    DEC[3]:
    ADD[4]:
    SUB[5]:
    INVERT[6]:
    SERIAL_INPUT_LSB[7]:
    SERIAL_INPUT_MSB[8]:
    SHIFT_LOGICAL_LEFT[9]:
    SHIFT_LOGICAL_RIGHT[10]:
    SHIFT_ARITHMETIC_LEFT[11]:
    SHIFT_ARITHMETIC_RIGHT[12]:
    ROTATE_LEFT[13]:
    ROTATE_RIGHT[14]: