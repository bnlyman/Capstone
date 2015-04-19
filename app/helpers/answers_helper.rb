module AnswersHelper
  def vote_badge(answer)
    if answer.helpful >= 0
      content_tag :span, answer.helpful, class: ['label','label-info'] 
    else  
      content_tag :span, answer.helpful, class: ['label','label-warning'] 
    end  
  end
end
