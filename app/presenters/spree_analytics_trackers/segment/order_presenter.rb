module SpreeAnalyticsTrackers
  module Segment
    class OrderPresenter < SpreeAnalyticsTrackers::BasePresenter
      private

      def serialize_resource(resource, options = {})
        {
          order_id: resource.number.to_s,
          total: resource.total&.to_f,
          shipping: resource.shipment_total&.to_f,
          tax: resource.additional_tax_total&.to_f,
          discount: resource.promo_total&.to_f,
          coupon: resource.promo_code,
          email: resource.user&.email,
          currency: resource.currency,
          products: resource.line_items.map { |li| serialize_line_item(li) },
          shipments: resource.shipments.map { |s| serialize_shipment(s) },
          payment_method: resource.payments.first&.payment_method&.name,
          stock_location_ids: resource.stock_locations.map(&:id),
          stock_location_names: resource.stock_locations.map(&:name),
        }
      end

      def serialize_shipment(shipment, options = {})
        {
          shipment_id: shipment.number.to_s,
          shipment_number: shipment.number.to_s,
        }
      private

      def serialize_line_item(line_item)
        {
          product_id: line_item.product_id&.to_s,
          variant_id: line_item.variant_id&.to_s,
          ean: line_item.variant&.ean&.to_s,
          sku: line_item.sku&.to_s,
          name: line_item.name,
          price: line_item.price&.to_f,
          quantity: line_item.quantity
        }
      end
    end
  end
end
