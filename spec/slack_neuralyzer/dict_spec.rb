require 'spec_helper'

describe SlackNeuralyzer::Dict do
  let(:channels_return) { { 'ok' => true, 'channels' => [{ 'id' => 'C000H9999', 'name' => 'general' }] } }
  let(:groups_return)   { { 'ok' => true, 'groups' => [{ 'id' => 'G000R9999', 'name' => 'private', 'is_mpim' => false }] } }
  let(:im_return)       { { 'ok' => true, 'ims' => [{ 'id' => 'I000M0000', 'user' => 'USLACKBOT' }] } }
  let(:mpim_return)     { { 'ok' => true, 'groups' => [{ 'id' => 'M000P0000', 'name' => 'mpdm--bot--pigbot-1' }] } }
  let(:users_return)    { { 'ok' => true, 'members' => [{ 'id' => 'U000S0000', 'name' => 'admin' }] } }
  before do
    allow(Slack).to receive(:channels_list).and_return(channels_return)
    allow(Slack).to receive(:groups_list).and_return(groups_return)
    allow(Slack).to receive(:im_list).and_return(im_return)
    allow(Slack).to receive(:mpim_list).and_return(mpim_return)
    allow(Slack).to receive(:users_list).and_return(users_return)
  end

  subject(:dict) { described_class.new('token') }
  context 'find channel id' do
    it '#find_channel_id' do
      expect(dict.find_channel_id('general')).to eq('C000H9999')
    end
    it '#find_group_id' do
      expect(dict.find_group_id('private')).to eq('G000R9999')
    end
    it '#find_im_id' do
      expect(dict.find_im_id('USLACKBOT')).to eq('I000M0000')
    end
    it '#find_mpim_id' do
      expect(dict.find_mpim_id('mpdm--bot--pigbot-1')).to eq('M000P0000')
    end
    it '#find_user_id' do
      expect(dict.find_user_id('admin')).to eq('U000S0000')
    end
  end

  context 'find channel name' do
    it '#find_channel_name' do
      expect(dict.find_channel_name('C000H9999')).to eq('general')
    end
    it '#find_group_name' do
      expect(dict.find_group_name('G000R9999')).to eq('private')
    end
    it '#find_im_name' do
      expect(dict.find_im_name('I000M0000')).to eq('USLACKBOT')
    end
    it '#find_mpim_name' do
      expect(dict.find_mpim_name('M000P0000')).to eq('mpdm--bot--pigbot-1')
    end
    it '#find_user_name' do
      expect(dict.find_user_name('U000S0000')).to eq('admin')
    end
  end

  context 'Catch Slack API error response' do
    let(:channels_return) { { 'ok' => false, 'error' => 'invalid_auth' } }
    it '#catch raise' do
      expect { described_class.new('token') }.to raise_error(
        SlackApi::Errors::ResponseError, 'SlackAPI: invalid_auth'
      )
    end
  end

  context 'Show all channels name' do
    it '#show_all_channels' do
      text = "All user direct:\n001. admin\n\nAll channels (public):\n001. general\n\nAll groups (private):\n001. private\n\nAll multiparty direct:\n001. mpdm--bot--pigbot-1\n"
      expect(described_class.new('token').show_all_channels).to eq(text)
    end
  end

  context 'Scan text to transform user id' do
    it '#scan_user_id_to_transform' do
      text = "<@U000S0000> 123"
      dict = described_class.new('token')
      expect(dict.scan_user_id_to_transform(text)).to eq('@admin 123')
    end
  end
end
