###################################################################################################
# Copyright (C) 2019 Maxim Integrated Products, Inc. All Rights Reserved.
#
# Maxim Integrated Products, Inc. Default Copyright Notice:
# https://www.maximintegrated.com/en/aboutus/legal/copyrights.html
#
# Written by RM
###################################################################################################
"""
Statistics for the pure Python computation modules
"""


macc = 0  # Hardware multiply-accumulates (Conv2D, etc.)
comp = 0  # Comparisons (ReLU, MaxPool)
add = 0  # Additions (EltwiseAdd, EltwiseSub, AvgPool)
mul = 0  # Multiplications (EltwiseMul)
bitwise = 0  # Bitwise OR/XOR (EltwiseXOR)
# div = 0  # Divisions (BatchNorm, SoftMax)
# exp = 0  # Exponentiations (SoftMax)

sw_macc = 0  # Software multiply-accumulates (FC)
sw_comp = 0  # Software comparisons (ReLU)

true_macc = 0  # Actual MAC ops, ignoring padding
true_sw_macc = 0


def ops():
    """
    Return number of ops computed in the simulator.
    """
    return macc + comp + add + mul + bitwise


def sw_ops():
    """
    Return number of software ops (FC) computed in the simulator.
    """
    return sw_macc + sw_comp


def print_summary(
        factor=1,
        debug=False,
):
    """
    Print ops summary stats.
    """
    print(f'Hardware: {factor * ops():,} ops ({factor * macc:,} macc; {factor * comp:,} '
          f'comp; {factor * add:,} add; '
          f'{factor * mul:,} mul; {factor * bitwise:,} bitwise)')
    if debug:
        print(f'          True MACs: {factor * true_macc:,}')
    if sw_macc:
        print(f'Software: {factor * sw_ops():,} ops ({factor * sw_macc:,} '
              f'macc; {factor * sw_comp:,} comp)')
