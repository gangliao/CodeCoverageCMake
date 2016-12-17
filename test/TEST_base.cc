#include <stdio.h>
#include "base.h"
#include <gtest/gtest.h>
#include <glog/logging.h>


TEST(Base, test) {
  CHECK_NE(2, 4);
  CHECK_NE(1, 4);
  CHECK_NE(baseline(0), 2);
}

int main(int argc, char** argv) {
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}