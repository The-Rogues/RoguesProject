# --MapStructureAutomatedTest Scene Main Script--
# Author: Fletcher Green

#------------------------------------------------------------------------------------
# Section: Declarations
#------------------------------------------------------------------------------------

extends Node

#------------------------------------------------------------------------------------
# Section: Functions
#------------------------------------------------------------------------------------

# --_ready Function--
# Description: Calls the test_structure function when the node is ready.
# Return: void.
func _ready() -> void:
	test_structure(0, 20000) # This means from 0 to 20000 exclusive.

# --test_structure Function--
# Description: Tests that a range of map seeds pass the structural requirements created by
#              the team.
# start_seed: The map seed to start testing from.
# end_seed: The seed to end testing at (exclusive).
# Return: void.
func test_structure(start_seed: int, end_seed: int) -> void:
	
	# Iterate over the specified range.
	for i in range(start_seed, end_seed):
		
		var map_manager: MapManager = MapManager.new(i) # Init a MapManager with i as the seed.
		
		# Print every 1000 error messages to avoid overloading the terminal.
		if i % 1000 == 0:
			print("--Seed: ", i, "--")
		
		# Print every 1000 success messages.
		if MapTester.test_map_structure(map_manager.map_structure):
			if i % 1000 == 0:
				print("Status: Success\n")
		else: # If structural test is unsuccessful execute this branch.
			
			# Adjust for only printing every 1000 messages.
			if i % 1000 != 0:
				print("--Seed: ", i, "--")
			
			# Print error message and exit function.
			print("Status: Failure\n")
			print("Automated testing halted. An error has occured.")
			return
	
	print("All automated tests have completed successfully.")
