#!/usr/bin/python3
# Author : HackTheClown

import os
import sys
import signal
import argparse

def hide(filepath):
	if not os.path.exists(filepath):
		print(f"Error: {filepath} does not exists")
		return

	fd = os.open(filepath, os.O_RDWR) # read/write perms
	os.unlink(filepath) # remove file from main fs
	pid = os.fork() # child process holding the file

	if pid > 0: # parent process
		print(f"File '{filepath}' is now hidden")
		print(f"Background process PID: {pid}")
		sys.exit(0)
	
	os.setsid()
	try:	# let the child process run in background
		signal.pause()
	finally:
		os.close(fd)


def retrieve(pid):
	fd_path = f"/proc/{pid}/fd"
	try:
		found = False
		for fd in os.listdir(fd_path):
			full_path = os.path.join(fd_path, fd)
			try:
				link = os.readlink(full_path)
				if "(deleted)" in link:
					print(f"Path to data: {full_path}")
					print(f"Original name: {link}")
					found = True
					retrieved = open(full_path, "rb")
					file = open(os.path.basename(link.replace(" (deleted)", "")), "wb")
					file.write(retrieved.read())
					retrieved.close()
					file.close()


			except OSError:
				continue
		if not found:
			print(f"No hidden files found for PID {pid}")
	except Exception as e:
		print(f"Error accessing PID {pid}: {e}")

 
if __name__ == "__main__":
	#if len(sys.argv) != 2:
	#	parser.print_help()
	#	sys.exit(1)

	parser = argparse.ArgumentParser(prog='ghost', usage='%(prog)s [hide] [retrieve]')

	parser.add_argument('--hide', help='Hide a file')
	parser.add_argument('--retrieve', help='Retrieve a hidden file by PID')

	args = parser.parse_args()
	if args.hide:
		hide(args.hide)

	if args.retrieve:
		retrieve(args.retrieve)
