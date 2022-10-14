from path import fileDir
def movi_simple(num, register):
    leftover = 0
    shift_amount = 0
    steps = []
    while(num!=1):
        rem = num % 2
        while(rem != 0):
            leftover= leftover+1
            steps.append("ADD r{register} 1\n".format(register=register))
            num = num -1
            rem = num % 2
        print("after taking care of remainder, {} ".format(num))
        num = num // 2
        shift_amount = shift_amount + 1
        print("after taking care of shift, {} ".format(num))
        if(len(steps) != 0):
            last_step = steps[len(steps) - 1].split()
            if(last_step and last_step[0] == 'SHF'):
                steps[len(steps) - 1] = "SHF r{register} {shift}\n".format(register=register,shift= int(last_step[2]) + 1 )
                continue
        steps.append("SHF r{register} {shift}\n".format(register=register,shift=1))
    steps.reverse()
    return steps

detail = movi_simple(61,1)
print(detail)
file2 = open(fileDir + '/test/movi.txt', 'w')
file2.writelines(detail)

file2.close()