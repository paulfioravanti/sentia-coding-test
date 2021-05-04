module Paginator
  module_function

  def paginate_array(collection, page)
    Kaminari.paginate_array(collection).page(page)
  end
end
