(in-package :cl-user)
(defpackage aiwiki.api.site
  (:use
   :cl
   :caveman2
   :aiwiki.utils.view
   :aiwiki.utils.request
   :aiwiki.model.site)
  (:export
   :index
   :update
   ))

(in-package :aiwiki.api.site)

(defun index ()
  (let ((site (site-info)))
    (render-json site)))

(defun update ()
  (let ((id (fetch-parameter "id"))
        (utm-campaign (fetch-parameter "utmCampaign"))
        (utm-source (fetch-parameter "utmSource"))
        (utm-medium (fetch-parameter "utmMedium"))
        (brand (fetch-parameter "brand"))
        (header (fetch-parameter "header"))
        (footer (fetch-parameter "footer"))
        (intro (fetch-parameter "intro"))
        (keywords (fetch-parameter "keywords")))
    (update-site-info id brand intro keywords header footer
                      utm-source utm-campaign utm-medium)
    (index)))
