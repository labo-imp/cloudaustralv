import  os
import  sys
import  time


if __name__ == "__main__":
    timestamp = time.strftime('%Y%m%d %H%M%S')
    args = sys.argv[1:]
    with open(args[0], "a") as arch:
      arch.write(timestamp + '\n')
      arch.close()

