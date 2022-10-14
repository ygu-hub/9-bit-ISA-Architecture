instructions = {
    'XOR': {"OpMode": "DataProcess", "OpCode": '000'},
    'ADD': {"OpMode": "DataProcess", "OpCode": '001'},
    'SUB': {"OpMode": "DataProcess", "OpCode": '010'},
    'MOV': {"OpMode": "DataProcess", "OpCode": '011'},
    'AND': {"OpMode": "DataProcess", "OpCode": '100'},
    'OR': {"OpMode": "DataProcess", "OpCode": '101'},
    'SHF': {"OpMode": "DataProcess", "OpCode": '110'},
    'MOVI': {"OpMode": "DataProcess", "OpCode": '111'},

    'STR': {"OpMode": "DataTransfer", "OpCode": '1'},
    'LDR': {"OpMode": "DataTransfer", "OpCode": '0'},

    'B': {"OpMode": "Branch", "OpCode": '000'},
    'BEQ': {"OpMode": "Branch", "OpCode": '001'},
    'BGT': {"OpMode": "Branch", "OpCode": '010'},
    'BLT': {"OpMode": "Branch", "OpCode": '011'},
    'BLE': {"OpMode": "Branch", "OpCode": '100'},
    'BGE': {"OpMode": "Branch", "OpCode": '101'},
    'BNE': {"OpMode": "Branch", "OpCode": '110'},
    'BXLR': {"OpMode": "Branch", "OpCode": '111'},


}


letter = ['X', 'Y']
translation = {ord('r'): None, ord('R'): None, ord('['): None, ord(']'): None}

#Z = opcode
# X = Parameter 1
# Y = Parameter 2
opmode = {
    'DataProcess': {"format": '0XXXYYZZZ', "params": [3, 2]},
    'DataTransfer': {"format": '10XXXYYYZ', "params": [3, 3]},
    'Branch': {"format": '11ZZZXXXX', "params": [4]},
}
