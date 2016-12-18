defmodule KratosApi.RelatedBillView do
  use KratosApi.Web, :view

  def render("related_bill.json", %{related_bill: related_bill}) do
    %{
      related_bill_id: related_bill.related_bill_id,
      reason: related_bill.reason
    }
  end

end
