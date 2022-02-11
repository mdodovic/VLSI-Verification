# VLSI-Verification
TBD

reg8_defected

The verification test of this component has covered:
 - no operation invoked (control register is equal to 0):
    outputs were unchanged: PASS!

 - single invoke of all operations (appropriate control bit is set; every operation has its own control bit written next to operation bellow):

    CLEAR[0]:
    LOAD[1]: PASS!
    INC[2]:
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