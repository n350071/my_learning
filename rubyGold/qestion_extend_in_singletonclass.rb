module M
  def moo
    'Moo'
  end
end

class Foo
  class << self
    include M
  end
end

class Bar
  extend M
end

class Baz
  class << self
    extend M
  end
end

Foo.moo #=> Moo
Bar.moo #=> Moo
Baz.moo #=> NoMethodError

# Bazにとってのmooはどこにいっちゃったの？
#
# 公式ドキュメント
# https://ruby-doc.org/core-2.5.0/doc/syntax/modules_and_classes_rdoc.html#label-Singleton+Classes
