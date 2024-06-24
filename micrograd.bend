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
# 5. Seems like I know nothing much about functional prpgramming, not a worry

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

# List count:
# List l -> uint -> uint
# returns the number of instances of Some s in list l.
List/count/aux = @acc @l @s
  match l {
    List/Nil: acc
    List/Cons: use acc = switch (== l.head s) {
      0: acc;
      _: (+ acc 1);
    }
    (List/count/aux acc l.tail s)
  }
List/count = @l @s
  (List/count/aux 0 l s)

### Defs and Constructor 
# object Value {value, grad, _prev, _backward}
def Value(val, var_name):
  # Default Arguments not supported so using this is the only Option 
  # Args: val 
  # Props: 
  #   0: name
  #   1: Value 
  #   2: grad 
  #   3: _prev (for traversal in the topo func)
  #   4: ops
  #   5: _grad_func
  # return: Node in graph 
  return {
    0: var_name,
    1: val,
    2: 0.0,
    3: [],
    4: Ops/None, 
    5: lambda x: x
  }


type Ops:
  add
  sub
  mul
  None

### Debugging and Repr 
def val_print(v1):
  # Crucial for debugging so wrote it pretty soon, yk
  return ["Value=", v1[1], "grad=", v1[2]]  

### OPS Backward 
def _backward(out, grad):
  v1 = List/index(out[3], 0)
  v2 = List/index(out[3], 1)
  match out[3]:
    case Ops/add:
      v1[2] += grad 
      v2[2] += grad  
      return [v1, v2]

    case Ops/sub:
      v1[2] += grad 
      v2[2] += grad 
    
      return [v1, v2]

    case Ops/mul:

      v1[2] += v2[2] * grad 
      v2[2] += v1[2] * grad 
      return [v1, v2]
    case _:
      return [v1, v2]

### OPS Forward 
def add(v1, v2, var_name):
  out = Value(v1[1] + v2[1], var_name)
  
  out[3] = [v1, v2]
  out[4] = Ops/add
  out[5] = _backward(out, v1, v2, Ops/add)
  return out 

def sub(v1, v2, var_name):
  out = Value(v1[1]- v2[1], var_name)
  
  out[3] = [v1, v2]
  out[4] = Ops/sub
  out[5] = _backward(out, v1, v2, Ops/sub)
  return out 

def mul(v1, v2, var_name):
  out = Value(v1[1] * v2[1], var_name)

  out[3] = [v1, v2]
  out[4] = Ops/mul
  out[5] = _backward(out, v1, v2, Ops/mul)
  return out

# def get_child_grad()

def _backward_impl(v, grad, grads):
  if (v[4] != Ops/None):
    child_grads = _backward(v, grad)
    match child_grads:
      case List/Cons:
        grad_var = child_grads.head
        grads[grad_var[0]] = grad_var[2]
        #grads = _backward_impl(grad_var, grads[grad_var[2]], grads)
        grads = _backward_impl(child_grads.tail, grad, grads)
        return grads
      case List/Nil:
        return grads
  else:
    return grads

### Backward Pass
def backward(out):
  return _backward_impl(out, 0.0, {"out": 0.0})

def apply_grads(value_and_grads):
  # Traverse the map and create all the vars and their Values 
  return 0

def main():
  v1 = Value(3, "v1")
  v2 = Value(2, "v2")    
  out = add(v1, v2, "out")
  grads = backward(out)
  return grads

