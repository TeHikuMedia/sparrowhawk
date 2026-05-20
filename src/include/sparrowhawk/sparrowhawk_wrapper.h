#pragma once
#include <string>

namespace sparrowhawk {

class NormalizerWrapper {
 public:
  NormalizerWrapper();
  ~NormalizerWrapper();

  bool Setup(const std::string& config_path, const std::string& prefix);
  bool Normalize(const std::string& input, std::string* output) const;

  NormalizerWrapper(const NormalizerWrapper&) = delete;
  NormalizerWrapper& operator=(const NormalizerWrapper&) = delete;

 private:
  struct Impl;
  Impl* impl_;
};

}  // namespace sparrowhawk
