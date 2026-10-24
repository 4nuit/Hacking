import time                                                                                                               
                                                                                                                          
def measure_time(func):                                                                                                   
                                                                                                                          
  def wrapper(*arg):                                                                                                      
      t = time.time()                                                                                                     
      res = func(*arg)                                                                                                    
      print("Function took " + str(time.time()-t) + " seconds to run")                                                    
      return res                                                                                                          
                                                                                                                          
  return wrapper                                                                                                          
                                                                                                                          
@measure_time                                                                                                             
def myFunction(n):                                                                                                        
  time.sleep(n)                                                                                                           
                                                                                                                          
if __name__ == "__main__":                                                                                                
    myFunction(2)      
