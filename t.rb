class T_tree
  attr_accessor :root

  def initialize
    @root = Trie_node.new()
    @root.children = []  #用于储存根节点的孩子节点
  end

  #词频统计，给空树插入一个单词，如果第2次又插入这个词，就会发现重复，然后count+1.
  def insert(next_child = @root, word)
    # 判断传入的字符串的第一个字母是否存在于当前节点的孩子内。
    exist_node = try(next_child.children, word[0])
    if exist_node
      # 继续判断node[1]是否在exist_node节点的儿子们中：
      if word.size == 1  #如果待插字符串只剩最后一个字母，证明这个单词没有后续了。
        # 词出现频率统计：
        exist_node.count += 1 #因为当前节点是一个词的最后的字符，所以加1.
        return
      else
        # 重复使用insert方法（），传入剩下的字符
        insert(exist_node, word.slice(1..-1))
      end
    else
      # "当前节点的孩子中不包括#{word[0]},插入#{word}"
      i = 0
      size = word.size
      while  i < size
        next_child =  _insert(next_child, word[i])
        # 词频统计：在插入的单词的最后生成的叶节点中：count+1
        if i == (size -1)
          next_child.count += 1
        end
        i += 1
      end
    end
  end

  # 字符串检索：查找单词是否已经存在于树中，如果不存在则打印
  def find(word)
    if _find(word)
      puts "#{word}存在于库中"
    else
      puts "#{word}不存在"
    end
  end

  def delete(word)
    if _find(word)
      puts "#{word}存在于库中, 是否删除它？ > true" #假设这里有个人工选择，选择true
      if _delete(word) == true
        puts "删除成功"
      else
        puts "不能删除前缀词"
      end
    else
      puts "#{word}不存在"
    end
  end

  private
    def _find(next_child = @root, word)
      exist_node = try(next_child.children, word[0])
      if exist_node
        # 只剩最后一个字母
        if word.size == 1
          return true
        else
          # word还有多个字母，继续查找比较。
          return _find(exist_node, word.slice(1..-1))
        end
      else
        return false
      end
    end

    def _delete(next_child = @root, word)
      exist_node = try(next_child.children, word[0])

      if word.size == 1 #当比较完最后一个字母后，后续进一步判断是否要删除
        #如果当前节点有儿子，证明word是一个前缀词，则不能删除它。
        if exist_node.children.size != 0
          return false
        else
          exist_node = nil
          return true
        end
      else  # word还有剩有多个字母，继续查找比较。
        result = _delete(exist_node, word.slice(1..-1))
        # _deltee递归的回归过程中，根据result判断是否删除当前节点：
        if  result == true
          exist_node = nil
        else
          return false
        end
      end
    end

    def try(childen, x)
      childen.each do |c|
        if c.node == x
          return c
        end
      end
      return false
    end

    def _insert(node, letter)
      new_node = Trie_node.new(letter)
      node.children << new_node
      return new_node
    end
end

class Trie_node
  attr_accessor :count, :node, :children

  def initialize(node = "")
    @node = node
    @count = 0 #记录从根节点到这个节点的，共走了多少次。
    @children = []
  end
end

tree = T_tree.new
tree.insert("hello")
tree.insert("hero")
tree.insert("hell")
p "---"
tree.find("hell")
tree.delete("he")
