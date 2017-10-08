/*
 * PackDirectory.h
 *
 *  Created on: 8 окт. 2017 г.
 */

#ifndef SRC_CTOOL1CD_PACKDIRECTORY_H_
#define SRC_CTOOL1CD_PACKDIRECTORY_H_

#include <vector>
#include <memory>
#include <boost/filesystem.hpp>

#include "Packdata.h"

class PackDirectory {
public:
	explicit PackDirectory(boost::filesystem::path& root_path);
	virtual ~PackDirectory();

	TStream* get_data(const char* datahash, bool &find);
private:
	std::vector<std::shared_ptr<Packdata>> packdates;
};

#endif /* SRC_CTOOL1CD_PACKDIRECTORY_H_ */
