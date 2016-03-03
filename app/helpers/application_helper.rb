module ApplicationHelper

  def cache_key_for(model_class, label = "")
    prefix = model_class.to_s.downcase.pluralize
    [prefix, label].join("-")
  end
  
end
