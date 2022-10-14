from path import fileDir
import sys
import inst_type


class assembler:

    def __init__(self):
        self.branchLines = {}
        self.currentLine = 0
        self.LUT = []
        self.count = 0

    def parseBranch(self, Lines):
        # first find all occurance of .label
        linenum = 0
        while(linenum < len(Lines)):
            
            if(len(Lines[linenum].strip())== 0 or Lines[linenum].strip()[0]=='#') :
                Lines.pop(linenum)
            elif(Lines[linenum].strip()[0] == '.'):
                self.branchLines[Lines[linenum].strip()[0:]] = linenum
                Lines.pop(linenum)
            else:
                linenum = linenum + 1
        linenum = 0
        # then, for each .label in the argument, replace it with  0..1...2, and store corresponding value in LUT
        for line in Lines:
            instr = line.strip().split()
            for token in instr:
                if(token[0] == '.' and len(instr) > 1):
                    self.LUT.append(self.branchLines[token] - linenum)
                    Lines[linenum] = line.replace(
                        token, str(self.count))
                    self.count = self.count + 1
            linenum = linenum + 1

    def instrToMachineCode(self, inst: str):
        inst = inst.upper()
        token: list[str] = inst.split()

        # Process opcode
        Instr = inst_type.instructions.get(token[0])

        if(Instr == None):

            if(token[0][0] == '.'):
                return ''

            print("fatal error, cannot find instruction " +
                  token[0], file=sys.stderr)
            sys.exit()

        OpMode = Instr.get('OpMode')
        OpCode = Instr.get('OpCode')

        template: str = inst_type.opmode[OpMode].get('format')
        template = template.replace("Z" * len(OpCode), OpCode)

        num_params = len(inst_type.opmode[OpMode].get('params'))

        if(len(token)-1 != num_params):
            print("Wrong number of parameters in instruction " +
                  inst, file=sys.stderr)
            sys.exit()
            

        for i in range(0, num_params):
            letter = inst_type.letter[i]
            # Process param1
            param1: str = token[i+1].translate(inst_type.translation)
            if(not param1.isdigit()):
                print("fatal error, invalid register " +
                      param1, file=sys.stderr)
                sys.exit()
            param1_length = inst_type.opmode[OpMode].get('params')[i]
            if(int(param1) >= 2 ** param1_length):
                print("fatal error, cant access register " +
                      param1, file=sys.stderr)
                sys.exit()

            template = template.replace(letter * param1_length,
                                        '{num:0{width}b}'.format(num=int(param1), width=param1_length))

        return template + '\n'

    def run(self, fileName):
        # Using readlines()
        file1 = open(fileDir + '/test/' + fileName + '.s', 'r')
        Lines = file1.readlines()
        file1.close()
        self.parseBranch(Lines)
        machine_code = []
        self.currentLine = 0
        # Strips the newline character
        for line in Lines:
            print("Line{}: {}".format(self.currentLine, line.strip()))
            machine_code.append(self.instrToMachineCode(line.strip()))
            self.currentLine += 1
        machine_code.append('111111111')
        file2 = open(fileDir + '/test/' + fileName + '_machinecode.txt', 'w')
        file2.writelines(machine_code)


        file2 = open(fileDir + '/modelsim2/machine_code.txt', 'w')
        file2.writelines(machine_code)


        file2.close()


    # instrToMachineCode("add r7 r3")
    # instrToMachineCode("B 11")
    # instrToMachineCode("STR r7 r3")
if __name__ == "__main__":
    converter = assembler()
    print('-----------------------------------------------------')
    converter.run('program3')
    print("LUT values : {table}".format(table=converter.LUT))
