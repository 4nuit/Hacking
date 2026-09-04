class Animal:
	"""Creates an Animal defined by its age and legs."""

	def __init__(self, age, legs):
		print("Animal created")
		self.age = age
		self.legs = legs

class Cat(Animal):
	"""Creates a Cat. A Cat is a named Animal and can interact with humans using miaowing or run away."""
	def __init__(self, age, name, legs):
		print("Cat created")
		#super().__init__(age, legs)
		super(Cat, self).__init__(age, legs)
		self.name = name

	def __str__(self):
		print("Cat printed")
		return f"""{self.name} has {self.age} years and {self.legs} legs"""

	def __eq__(self, other):
		print("Comparing cats")
		return self.name == other.name and self.age == other.age and self.legs == other.legs

	def miaow(self):
		print("Meow")

	def run_away(self):
		#self.miaow()
		Cat.miaow(self)
		print("runs away")

animal = Animal(1, 2)
print(f"""Docstring: {animal.__doc__}""")

for key, value in animal.__dict__.items():
    print(f"{key}: {value}")

print("\n")


titi = Cat(2, "titi", 4)
toto = Cat(2, "titi", 4)

print(f"""Docstring: {titi.__doc__}""")
print(titi)
print("titi is toto" if titi == toto else "titi is not toto")
print("titi is an Animal: ", isinstance(titi,Animal))

print("\n")

# Animal.__init__(titi, 3, 4)
print("Titi's birthday:")
super(Cat, titi).__init__(3,4)
print(titi)
titi.run_away()
print("\n")

for key, value in titi.__dict__.items():
    print(f"{key}: {value}")
