require 'spec_helper'

describe License do

  before do
    client
  end

  context 'params' do

    it 'stores params correctly' do
      subject = License.new("image_id" =>"42194962",
                            "download" =>{"url" =>"https://download.shutterstock.com/shutterstock_42194962.jpg"},
                            "allotment_charge" => 1)


      expect(License).to respond_to(:license)

      expect(subject).to_not be_nil
      expect(subject.image_id).to eq 42194962
      expect(subject.download).to eq "https://download.shutterstock.com/shutterstock_42194962.jpg"
      expect(subject.allotment_charge).to eq 1
    end

  end

  context 'license' do


    let(:subscription_id) { "s30187600" }
    let(:bad_image_id) { 509_205_923_049 }

    context 'single' do

      let(:bad_subscription_id) { "s987654" }
      let(:image_id) { 138_869_051 }
      let(:image2) { Image.new("id" => "145104193") }
      let(:image3) { { "image_id" => "157910507" } }
      let(:vector_image_id) { 109675343 }


      it 'returns error when neither image or subscription id passed' do
        expect { License.license(subscription_id: subscription_id) }.to raise_error(ArgumentError)
        expect { License.license(image_id: image_id) }.to raise_error(ArgumentError)
      end

      it 'returns error when incorrect image used' do
        license = License.license(subscription_id: subscription_id, image_id: bad_image_id)
        expect( license.error ).to eq "Media unavailable"
      end

      it 'returns error when incorrect subscription used' do
        license = License.license(subscription_id: bad_subscription_id, image_id: image_id)
        expect( license.error ).to eq "Subscription is unusable"
      end

      it 'licenses single image' do
        license = License.license(subscription_id: subscription_id, image_id: image_id, format: "jpg", size: "huge")
        expect( license ).to be_a License
        expect( license.image_id ).to eq image_id
        expect( license.error ).to be nil
        expect( license.allotment_charge ).to be 1
        expect( license.download ).to be_a String
        expect( license.download ).to match /download\.shutterstock/
      end

      it 'licenses single image from Image.new' do
        license = License.license(subscription_id: subscription_id, image_id: image2, format: "jpg", size: "huge")
        expect( license ).to be_a License
        expect( license.image_id ).to eq image2.id
        expect( license.error ).to be nil
        expect( license.allotment_charge ).to be 1
        expect( license.download ).to be_a String
        expect( license.download ).to match /download\.shutterstock/
      end

      it 'licenses single image from hash' do
        license = License.license(subscription_id: subscription_id, image_id: image3, format: "jpg", size: "huge")
        expect( license ).to be_a License
        expect( license.image_id ).to eq image3["image_id"].to_i
        expect( license.error ).to be nil
        expect( license.allotment_charge ).to be 1
        expect( license.download ).to be_a String
        expect( license.download ).to match /download\.shutterstock/
      end

      it 'error when format is eps but size is not vector' do
        expect { License.license(subscription_id: subscription_id, image_id: vector_image_id, format: "eps") }.to raise_error(ArgumentError)
      end

      it 'licenses vector image' do
        license = License.license(subscription_id: subscription_id, image_id: vector_image_id, format: "eps", size: "vector")
        expect( license ).to be_a License
        expect( license.image_id ).to eq vector_image_id
        expect( license.error ).to be nil
        expect( license.allotment_charge ).to be 1
        expect( license.download ).to be_a String
        expect( license.download ).to match /download\.shutterstock/
      end

      it 'licenses single image with smaller size' do
        license = License.license(subscription_id: subscription_id, image_id: image3, format: "jpg", size: "small")
        expect( license ).to be_a License
        expect( license.image_id ).to eq image3["image_id"].to_i
        expect( license.error ).to be nil
        expect( license.download ).to be_a String
        expect( license.download ).to match /download\.shutterstock/
      end

      it 'license fails when subscription doesn\'t allow' do
        expect { License.license(subscription_id: subscription_id, image_id: image3, format: "tiff", size: "small") }.to raise_error(FailedResponse)
      end

      it 'licencing same image twice does not give error' do
        license = License.license(subscription_id: subscription_id, image_id: image3, format: "jpg", size: "huge")
        expect( license ).to be_a License
        license = License.license(subscription_id: subscription_id, image_id: image3, format: "jpg", size: "huge")
        expect( license.allotment_charge ).to eq 0
      end


    end

    context 'multiple' do

      let(:image_ids) { [312464573, 313292420, 314250722] }
      let(:image_ids_as_images) { [431616757, 461729398, 94306576].map{|id| Image.new("id" => id)} }

      it 'returns error when neither image or subscription id passed' do
        expect { License.license_multiple(subscription_id: subscription_id) }.to raise_error(ArgumentError)
        expect { License.license_multiple(image_id: image_ids) }.to raise_error(ArgumentError)
      end

      it 'licenses multiple images' do
        licenses = License.license_multiple(subscription_id: subscription_id, image_id: image_ids, format: "jpg", size: "huge")
        expect( licenses ).to be_a Licenses
        expect( licenses.count ).to eq 3
        expect( licenses.errors ).to be nil

        first_license = licenses.first
        expect( first_license ).to be_a License
        expect( first_license.image_id ).to eq image_ids.first
        expect( first_license.error ).to be nil
        expect( first_license.allotment_charge ).to be 1
        expect( first_license.download ).to be_a String
        expect( first_license.download ).to match /download\.shutterstock/
      end

      it 'licenses multiple images from Image.new' do
        licenses = License.license_multiple(subscription_id: subscription_id, image_id: image_ids_as_images, format: "jpg", size: "small")
        expect( licenses ).to be_a Licenses
        expect( licenses.count ).to eq 3
        expect( licenses.errors ).to be nil

        first_license = licenses.first
        expect( first_license ).to be_a License
        expect( first_license.image_id ).to eq image_ids_as_images.first.id
        expect( first_license.error ).to be nil
        expect( first_license.allotment_charge ).to be 1
        expect( first_license.download ).to be_a String
        expect( first_license.download ).to match /download\.shutterstock/
      end

      it 'returns error in Licenses when incorrect image used' do
        licenses = License.license_multiple(subscription_id: subscription_id, image_id: [bad_image_id])
        expect( licenses.errors ).to be_a Array
        expect( licenses.errors.first["message"] ).to eq "Failed to license 1 image"
        expect( licenses.first.error ).to eq "Media unavailable"
      end
    end

    context 'editorial_acknowledgement' do

      let(:image_id_needing_ed_ack) { 204_501_694 }


      it 'returns error if requesting an image that needs editorial acknowledgement' do
        license = License.license(subscription_id: subscription_id, image_id: image_id_needing_ed_ack)
        expect( license ).to be_a License
        expect( license.image_id ).to eq image_id_needing_ed_ack
        expect( license.error ).to eq "Editorial status must be acknowledged"
      end

      it 'returns licenced image if ed ack is sent' do
        license = License.license(subscription_id: subscription_id, image_id: image_id_needing_ed_ack, editorial_acknowledgement: true)
        expect( license ).to be_a License
        expect( license.image_id ).to eq image_id_needing_ed_ack
        expect( license.error ).to be nil
        expect( license.allotment_charge ).to be 1
        expect( license.download ).to be_a String
        expect( license.download ).to match /download\.shutterstock/
      end


    end
    context 'license from image object' do

      let(:image) { Image.new("id" => "42194962") }

      it 'using found subscription' do
        license = image.license
        expect( license ).to be_a License
        expect( license.image_id ).to eq image.id
        expect( license.error ).to be nil
        expect( license.allotment_charge ).to be 1
        expect( license.download ).to be_a String
        expect( license.download ).to match /download\.shutterstock/
      end

      it 'vector image' do
        image = Image.new("id" => "110641004")
        license = image.license(format: "eps", size: "vector")
        expect( license ).to be_a License
        expect( license.image_id ).to eq image.id
        expect( license.error ).to be nil
        expect( license.allotment_charge ).to be 1
        expect( license.download ).to be_a String
        expect( license.download ).to match /download\.shutterstock/
      end

      it 'sends editorial_acknowledgement when image needs it' do
        license = Image.new("id" => "204501694").fill.license
        expect( license ).to be_a License
        expect( license.image_id ).to eq 204501694
        expect( license.error ).to be nil
        expect( license.download ).to be_a String
        expect( license.download ).to match /download\.shutterstock/
      end

    end

  end

end
