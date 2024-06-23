

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
    "value": val,
    "grad": 0.0,
    "children": []
}

object Val {value, grad, _prev}

def value_def(val):
  return Val {value: val, grad: 0.00, _prev: []}

def Val.print(v1):
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
  return temp.value

def main():
  a = value_def(10)
  b = value_def(20)
  out = value_def(30) 
  
  open Val: out
  out._prev = [a, b] 
  return Val.print(List/index(out._prev, 0)) 
