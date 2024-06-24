

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

def Value(val):
  return {
    0 : val,
    1 : 0.0,
    2 : []
}

object Val {value, grad, _prev}

def value_def(val):
  return Val {value: val, grad: 0.00, _prev: []}


def print_val(v1):
  open Val: v1 
  return ["Value=", v1.value, "grad=", v1.grad ]  

type Ops:
  add 
  sub
  mul

def backward(ops):
  match ops:
    case Ops/add:
      return "+"
    case Ops/sub:
      return "-"
    case Ops/mul:
      return "*"
    case _:
      return "_"

def sum(tree):
  fold tree:
    case Tree/Node:
      return tree.left + tree.right
    case Tree/Leaf:
      return tree.value


def reverse(list):
  fold list with id=1:
    case List/Nil:
      return 0
    case List/Cons:
      return list.head + list.tail

def Val.print_a(out, a, b):
  open Val: out
  temp =  List/index(out._prev, 0)
  open Val: temp
  return print(temp)

def Val.print():
  return 0

def print_my_val(out, a):
  a = set_grad(a)
  return print_value(List/index(out[2], 0))

def set_grad(v1):
  v1[1] += 20.0
  return v1

def print_value(v1):
  return ["value=", v1[0], "grad=", v1[1]]

def grads_eval(my_list, grads):
  match my_list:
    case List/Cons:
      grads[my_list.head[0]] = my_list.head[1]  + 10     
      return grads_eval(my_list.tail, grads)
    case List/Nil:
      return grads
def print_value_s(a):
  return ["value=", a]

def main():
  a = Value(10)
  b = Value(23)
  my_list = [a, b]
  d = 10 + Map/get(List/index(my_list, 1), 0)
  return print_value_s(d)
