describe OvirtMetrics::HostSamplesHistory do
  shared_examples_for "HostSamplesHistory" do
    context "#cpu_usagemhz_rate_average" do

      it "when host_configuration is nil" do
        host_history = described_class.new(:host_configuration => nil)
        expect(host_history.cpu_usagemhz_rate_average).to eq(0)
      end

      context "when host_configuration exists" do
        before(:each) { @host_configuration = OvirtMetrics::HostConfiguration.new }
        it "and cpu_speed_mh and number_of_cores is nil" do
          host_history = described_class.new(:host_configuration => @host_configuration)
          expect(host_history.cpu_usagemhz_rate_average).to eq(0)
        end

        it "and cpu_speed_mh is nil and number_of_cores is numeric" do
          host_history = described_class.new(:host_configuration => @host_configuration)
          allow(@host_configuration).to receive_messages(:number_of_cores => 1)
          expect(host_history.cpu_usagemhz_rate_average).to eq(0)
        end

        it "and cpu_speed_mh is numeric and number_of_cores is nil" do
          host_history = described_class.new(:host_configuration => @host_configuration)
          allow(@host_configuration).to receive_messages(:cpu_speed_mh => 2048.0)
          expect(host_history.cpu_usagemhz_rate_average).to eq(0)
        end

        it "and cpu_speed_mh is numeric and number_of_cores is numeric" do
          allow(@host_configuration).to receive_messages(:cpu_speed_mh => 2048.0)
          allow(@host_configuration).to receive_messages(:number_of_cores => 2)

          host_history = described_class.new(
            :cpu_usage_percent  => 50,
            :host_configuration => @host_configuration
          )
          expect(host_history.cpu_usagemhz_rate_average).to eq(2048.0)
        end
      end
    end
  end

  context "RHEV 3.1" do
    before(:each) { load_rhev_31 }
    it_should_behave_like "HostSamplesHistory"
  end

  context "RHEV 4" do
    before(:each) { load_rhev_40 }
    it_should_behave_like "HostSamplesHistory"
  end
end
