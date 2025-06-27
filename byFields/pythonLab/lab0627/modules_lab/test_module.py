print("module's __name__ printer")
print(__name__)

PI = 3.14

def number_input():
    output = input("반지름 :")
    return float(output)

# 원의 둘레
def get_cir_radius(radius):
    return 2 * PI * radius


def get_cir_area(radius):
    return PI * (radius**2)

if __name__ == "__main__":
    print(get_cir_area(10))
    print(get_cir_radius(10))
    # -> 이 내용은 test_module.py가 직접적으로 실행됐을 때만 실행이 됨 -> 얘가 main으로 실행됐을 때만 실행이됨
    # 얘가 import 된 상태에서는 __name__이 test_module이라서 실행이 안됨