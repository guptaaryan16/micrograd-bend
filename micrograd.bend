#                       
#                       Implementing Micrograd in Bend 
#                       A Weekend Project by Aryan Gupta 
#                            Hope it's fun to use !!!
#                 Copyright (c) 2024 g_aryan16. All Rights Reserved.
#                                  MIT License
#
#
## Notes for building this 
# 1. We can use object bind function methods and create constructors, so cool
# 2. There is no print method for representing individual values so , we may need to write that stuff on 
#     our own, Not a big deal.,,,
# 3. Less support on having lists within objects, need to see a work around this.
# 4. Seems like we can mutate the var of an object inside a function, not sure if it is a bug 



### List
# Taken from https://github.com/HigherOrderCO/Bend/blob/main/examples/list.bend
# List index:
# List l -> Some s
# returns the value of a specific list index i, or * if the index doesn't exist.
List/index = @l @i
  match l {
    List/Cons: 
      switch i {
        0: l.head
        _: (List/index l.tail (i-1))
      }
    List/Nil: *
  }

# List head:
# List l -> Some s
# returns the first item in the list, or [] if the list is empty.
List/head = @l
  match l {
    List/Cons: l.head
    List/Nil: []
  }

### Map 
#

### Set 
#
#

### Defs and Constructor 
object Value {value, grad, _prev, _backward}

type Ops:
  add
  sub
  mul

def identity(x):
  return x

def Value.define(num):
  return Value {value: num, grad: 0.0, _prev: [], _backward: identity}


### Debugging and Repr 
def Value.print(v1):
  # Crucial for debugging so wrote it pretty soon, yk
  open Value: v1
  return ["Value=", v1.value, "grad=", v1.grad]  

### OPS Backward 
def _backward(out, v1, v2, ops):
  open Value: out
  open Value: v1
  open Value: v2

  match ops:
    case Ops/add:
      v1.grad += out.grad 
      v2.grad += out.grad 
      return "+"
    case Ops/sub:
      v1.grad -= out.grad 
      v2.grad -= out.grad 
      return "-"
    case Ops/mul:
      v1.grad += v2.grad * out.grad 
      v2.grad += v1.grad * out.grad 
      return "*"
    case _:
      return "_"

### OPS Forward 
def Value.add(v1, v2):
  open Value: v1
  open Value: v2
  out = Value.define(v1.value + v2.value)
  
  open Value: out
  
  out._prev = [v1, v2]
  out._backward = _backward(out, v1, v2, Ops/add)
  return out 

def Value.sub(v1, v2):
  open Value: v1
  open Value: v2
  out = Value.define(v1.value - v2.value)
  
  open Value: out

  out._prev = [v1, v2]
  out._backward = _backward(out, v1, v2, Ops/sub)
  return out 

def Value.mul(v1, v2):
  open Value: v1
  open Value: v2
  out = Value.define(v1.value * v2.value)
  
  open Value: out
  
  out._prev = [v1, v2]
  out._backward = _backward(out, v1, v2, Ops/mul)
  return out

### Topological Sort 
def topo_sort(v1, visited):
  res = []
  visited = {}
  # Now we need to visit each 

  return res

### Backward Pass
def backward(out):
  top = []
  visited = []
  # Implement topiological Sort Function for the graph
  
  out.grad = 1.000
  # Implement the Optional Sort 
  
  return 0

def main():
  v1 = Value.define(3)
  v2 = Value.define(2)    
  out = Value.mul(v1, v2)
  open Value: out
  return Value.print(List/index(out._prev, 0))
