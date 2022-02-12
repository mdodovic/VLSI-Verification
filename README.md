# VLSI-Verification
TBD

reg8_defected

The verification test of this component has covered:
 - no operation invoked (control register is equal to 0): 

    outputs were unchanged: PASS!

 - single invoke of all operations (appropriate control bit is set; every operation has its own control bit written next to operation bellow):

      CLEAR[0]: FAIL! 
      
      Clean operation functionality: load value 8'h00 to the value (named ```out```) and load 1'b0 to the register's most and least significant bits (named shortly ```msb``` and ```lsb```). Instead, it loads value 8'h01 to the register's value. One verification block for representation:
      ```
      #  expected {msb = 0, out = 00000000, lsb = 0}
      #   != got  {msb = 0, out = 00000001, lsb = 0}
      ```
      LOAD[1]: PASS!
      
      Load operation functionality: load value from input to out.
      
      INC[2]: FAIL! 
      
      Inc operation functionality: increment out by one. Instead, it decrements out value by 1. Three successive blocks for representation:
      ```
      #  expected {msb = 0, out = 10011101, lsb = 0} // initial state
      #  == got   {msb = 0, out = 10011101, lsb = 0} // initial state
      ```
      ```
      #  expected {msb = 0, out = 10011110, lsb = 0} // + 1
      #  != got   {msb = 0, out = 10011100, lsb = 0} // - 1
      ```
      ```
      #  expected {msb = 0, out = 10011111, lsb = 0} // + 2
      #  != got   {msb = 0, out = 10011011, lsb = 0} // - 2
      ```

      DEC[3]: FAIL!

      Dec operation functionality: decrement out by one. Instead, it increments out value by 1. Three successive blocks for representation:
      ```
      #  expect {msb = 0, output = 11100000, lsb = 0} // initial state
      #  == got {msb = 0, output = 11100000, lsb = 0} // initial state
      ```
      ```
      #  expect {msb = 0, output = 11011111, lsb = 0} // - 1
      #  == got {msb = 0, output = 11100001, lsb = 0} // + 1
      ```
      ```
      #  expect {msb = 0, output = 11011110, lsb = 0} // - 2
      #  == got {msb = 0, output = 11100010, lsb = 0} // + 2
      ```

      ADD[4]: PASS!
      
      Add operation functionality: add out value and value from input. If there is any carry this will be stored in msb.
      
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