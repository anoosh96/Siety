module StaticPagesHelper

def full_title(page_title = "")
  base_title = "RoR Tutorial Sample App"

  if page_title.empty?
    base_title
  else
    page_title + " | " + base_title

  end

end

def flashAlert(alert="")
  base_alert = "alert"

  if(alert.empty?)
    base_alert
  else
    base_alert + " " + "alert-" + alert
  end
end

end
