import test_module as t

radius = t.number_input()

print("area: ",t.get_cir_area(radius), "diameter: ", t.get_cir_radius(radius))

print("main's __name__ printer")
print(__name__)