#include "sparrowhawk/sparrowhawk_wrapper.h"
#include "sparrowhawk/normalizer.h"

namespace sparrowhawk {

struct NormalizerWrapper::Impl {
  speech::sparrowhawk::Normalizer normalizer;
};

NormalizerWrapper::NormalizerWrapper() : impl_(new Impl()) {}
NormalizerWrapper::~NormalizerWrapper() { delete impl_; }

bool NormalizerWrapper::Setup(const std::string& config_path,
                               const std::string& prefix) {
  return impl_->normalizer.Setup(config_path, prefix);
}

bool NormalizerWrapper::Normalize(const std::string& input,
                                   std::string* output) const {
  return impl_->normalizer.Normalize(input, output);
}

}  // namespace sparrowhawk
