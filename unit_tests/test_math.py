import src.very_cool_functions as vcf
import pytest

def test_addNumbers():
    assert vcf.addNumbers(4,5) == 9
    assert vcf.addNumbers(0,0) == 0