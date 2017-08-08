module Enumerable
  def my_each
    if block_given?
      arr = self.to_a
      i = 0
      while i < arr.length
        yield(arr[i])
        i += 1
      end
      self
    else
      self.to_enum
    end
  end
end

module Enumerable
  def my_each_with_index
    if block_given?
      arr = self.to_a
      i = 0
      while i < arr.length
        yield(arr[i], i)
        i += 1
      end
      self
    else
      self.to_enum
    end
  end
end

module Enumerable
  def my_select
    if block_given?
      selected_arr = []
      self.my_each {|i| selected_arr.push(i) if yield(i) == true}
      selected_arr
    else
      self.to_enum
    end
  end
end

module Enumerable
  def my_all?
    true_for_all = true
    if block_given?
      self.my_each {|i| true_for_all = false if !(yield(i))}
    else
      self.my_each {|i| true_for_all = false if !i}
    end
    true_for_all
  end
end

module Enumerable
  def my_any?
    match_for_any = false
    if block_given?
      self.my_each {|i| match_for_any = true if yield(i)}
    else
      self.my_each {|i| match_for_any = true if i}
    end
    match_for_any
  end
end

module Enumerable
  def my_none?
   !(self.my_any?)
  end
end

module Enumerable
  def my_count(*input)
    count = 0
    if block_given?
        self.my_each {|i| count += 1 if yield(i)}
    else
      if input.length == 0
        self.my_each {|i| count +=1}
      else
        puts "running"
        self.my_each do |i|
          count +=1 if i == input[0]
        end
      end
    end
    count
  end
end

module Enumerable
  def my_map(&a_proc)
    new_arr = []
    if a_proc #i.e. if Proc given
        self.my_each {|i| new_arr << a_proc.call(i)}
    elsif block_given?
        self.my_each {|i| new_arr << yield(i)}
    else
      new_arr = self.to_enum
    end
    new_arr
  end
end

module Enumerable
  def my_inject(*input)
    arr = self.to_a
    if block_given? or input.length == 0 #if no input, then it must include a block (or else, display 'no block given' error)
      memo = (input.length == 0 ? arr[0] : input[0]) #if no arg, set initial value to first element; else set to provided intiial value
      i = 0
      arr.my_each do
        memo = yield(memo, arr[i+1]) if (i < arr.length - 1) #prevent iterating the last item
        i += 1
      end
      memo # return result
      if input.length == 2 # if there is block AND 2 args, run the 2nd arg (ie. symbol) after completing the block
        arr.my_inject(memo , input[1])
      end
    else #no block
      if input.length == 1 #one arg, i.e. Symbol
          memo = arr[0] #set initial value to first element
          i = 0
          arr.my_each do
            memo = memo.send(input[0], arr[i+1]) if (i < arr.length - 1) #prevent iterating the last item
            i += 1
          end
          memo #result
      else # two args; i.e. first input: initial value, second input: Symbol
          memo = input[0]
          i = 0
          arr.my_each do
            memo = memo.send(input[1], arr[i]) if (i < arr.length) #since there is inital value, the first/last element needs to be evaluated
            i += 1
          end
          memo
      end
    end
  end
end

def multiply_els(arr)
  arr.my_inject(:*)
end
