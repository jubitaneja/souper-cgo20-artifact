import sys

timeout_count = 0


def getWidth(lines):
    reg = ""
    for line in lines:
        if line.startswith("infer"):
            reg = line.split(' ')[1]
    for line in lines:
        if line.startswith(reg):
            w = int(line.split("i")[1].split(" ")[0])
            return w


# return: (lower, upper, width)
def getSK(lines):
    for line in lines:
        if line.startswith("known from Souper"):
            if "timeout" in line:
                return None
            else:
                lower = int(line.split("[")[1].split(",")[0])
                higher = int(line.split(",")[1].split(")")[0])
                return (lower, higher)

def getLK(lines):
    for line in lines:
        if line.startswith("known from compiler"):
            if "oops" in line:
                return None
            else:
                lower = int(line.split("[")[1].split(",")[0])
                higher = int(line.split(",")[1].split(")")[0])
                return (lower, higher)

def isFull(p):
    return p[0] == -1 and p[1] == -1

def formalize(a, w):
    if a >= 0:
        return a
    return 2 ** w + a

def countRange(K, w):
    if K[0] < K[1]:
        return K[1] - K[0]
    else:
        upper = 2 ** w - K[0]
        lower = K[1]
        return upper + lower


printlstronger = 0
printsstronger = 0
printsamecount = 0


with open('range-std', 'r') as file:
    souper_stronger = 0
    llvm_stronger = 0
    have_same_count = 0

    data = file.read().split('------------------------------------------------------')[:-1]

    it = data[0]
    for it in data:
        lines = it.split('\n')
        SK = getSK(lines)
        if SK == None:
            continue
        W = getWidth(lines)
        LK = getLK(lines)
        if LK == None:
            continue

        if isFull(SK) and not isFull(LK):
            if printlstronger:
                print it
            llvm_stronger = llvm_stronger + 1
            continue

        if isFull(LK) and not isFull(SK):
            if printsstronger:
                print it
            souper_stronger = souper_stronger + 1
            continue

        LK = (formalize(LK[0], W), formalize(LK[1], W))
        SK = (formalize(SK[0], W), formalize(SK[1], W))

        countLK = countRange(LK, W)
        countSK = countRange(SK, W)

        if countLK < countSK:
            if printlstronger:
                print it
            llvm_stronger = llvm_stronger + 1
            continue
        elif countLK > countSK:
            if printsstronger:
                print it
            souper_stronger = souper_stronger + 1
            continue
        else:
            if printsamecount:
                print it
            have_same_count = have_same_count + 1

    sys.stderr.write("Souper stronger #: " + str(souper_stronger) + "\n")
    sys.stderr.write("LLVM stronger #: " + str(llvm_stronger) + "\n")
    sys.stderr.write("Same count but not same range #: " + str(have_same_count) + "\n")

#    print it
