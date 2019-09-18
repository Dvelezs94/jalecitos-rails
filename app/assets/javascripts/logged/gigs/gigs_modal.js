$(document).on('turbolinks:load', function() {
    modals('report_gig', 'reportObjectModal', "reportgigbtn");
    modals('report_gig', 'reportObjectModal', "reportgigbtndesk");
    modals('recommend_gig', 'recommendationModal', "recommendgigbtn");
    modals('not_recommend_gig', 'recommendationModal', "notrecommendgigbtn");
    modals('', 'editReviewModal', "edit-review", "block", false, true);
    modals('', 'reportReviewModal', "report-review", "block", false, true);
});
