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
      
      SUB[5]: FAIL!
      
      Sub operation functionality: sub out value with value from input. If there is any borrow this will be stored in msb. Instead, it add out value and value from input. Two successive blocks for representation:
      ```
      input = 00111011
      #  expect {msb = 0, output = 01000010, lsb = 0} // initial state
      #  == got {msb = 0, output = 01000010, lsb = 0} // initial state
      ```
      ```
      #  expect {msb = 0, output = 00000111, lsb = 0} // output = output - input
      #  == got {msb = 0, output = 01111101, lsb = 0} // output = output + input
      ```

      INVERT[6]: FAIL!

      Invert operation functionality: invert out value. Instead, it leaves out as it was before operation. Three successive blocks for representation:
      ```
      #  expect {msb = 0, output = 01000001, lsb = 0} // initial state
      #  == got {msb = 0, output = 01000001, lsb = 0} // initial state
      ```
      ```
      #  expect {msb = 0, output = 10111110, lsb = 0} // inverted
      #  == got {msb = 0, output = 01000001, lsb = 0} // same
      ```
      ```
      #  expect {msb = 0, output = 01000001, lsb = 0} // inverted (double invert)
      #  == got {msb = 0, output = 01000001, lsb = 0} // same
      ```

      SERIAL_INPUT_LSB[7]: FAIL!

      Serial input LSB operation functionality: shift out for 1 place left (msb will become the most significant bit of out value) and set out's least significant bit with given input lsb value. Instead, it properly shifts the out value but always fill the out's least significant bit with 1'b1. 

      First situation (```input lsb = 1'b1```), two successive blocks for representation:
      ```
      #  expect {msb = 0, output = 10000011, lsb = 0} // initial state
      #  == got {msb = 0, output = 10000011, lsb = 0} // initial state
      ```
      ```
      #  expect {msb = 1, output = 00000111, lsb = 0} // shift + set 1 to the out's least significant bit
      #  == got {msb = 1, output = 00000111, lsb = 0} // shift + set 1 to the out's least significant bit 
      ```
            Second situation (```input lsb = 1'b0```), two successive blocks for representation:
      ```
      #  expect {msb = 0, output = 10100111, lsb = 0} // initial state
      #  == got {msb = 0, output = 10100111, lsb = 0} // initial state
      ```
      ```
      #  expect {msb = 1, output = 01001110, lsb = 0} // shift + set 0 to the out's least significant bit
      #  == got {msb = 1, output = 01001111, lsb = 0} // shift + set 1 to the out's least significant bit
      ```

      SERIAL_INPUT_MSB[8]: PASS!

      Serial input MSB operation functionality: shift out for 1 place right (lsb will become the least significant bit of out value) and set out's most significant bit with given input msb value. 
      
      SHIFT_LOGICAL_LEFT[9]: PASS!

      Shift logical left operation functionality: shift out for 1 place left (msb will become the most significant bit of out value) and set out's least significant bit to 1'b0. 

      SHIFT_LOGICAL_RIGHT[10]:
      SHIFT_ARITHMETIC_LEFT[11]:
      SHIFT_ARITHMETIC_RIGHT[12]:
      ROTATE_LEFT[13]:
      ROTATE_RIGHT[14]: